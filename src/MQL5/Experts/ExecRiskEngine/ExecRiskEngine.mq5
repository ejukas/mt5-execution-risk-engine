#property strict
#property version   "0.1.0.200"
#property description "MT5 Execution & Risk Control Engine - sample EA wiring"

#include <Trade/Trade.mqh>
#include <ExecRiskEngine\RiskLayer.mqh>
#include <ExecRiskEngine\Logger.mqh>


CTrade trade;

input double InpMaxDailyDDMoney = 50.0; // daily max drawdown in account currency (0=disabled)
input bool     InpLogEnabled  = true;
input LogLevel InpLogMinLevel = LOG_INFO;
input KillMode InpKillMode = KILL_SOFT;


Logger logg;


RiskLayer risk;


int OnInit()
{
   const long login = AccountInfoInteger(ACCOUNT_LOGIN);
   Print("ExecRiskEngine v0.1.0 loaded. Login=", login);

   risk.Update(AccountInfoDouble(ACCOUNT_EQUITY));
   string prefix = "ExecRiskEngine " + _Symbol + " " + EnumToString((ENUM_TIMEFRAMES)_Period);
   
   logg.Configure(InpLogEnabled, InpLogMinLevel, prefix);
   risk.SetKillMode(InpKillMode);

   logg.Write(LOG_INFO, "Loaded. Login=" + (string)AccountInfoInteger(ACCOUNT_LOGIN));

   return(INIT_SUCCEEDED);
}



void OnDeinit(const int reason)
{
   Print("ExecRiskEngine unloaded. reason=", reason);
}

void OnTick()
{
   const double equity = AccountInfoDouble(ACCOUNT_EQUITY);

   risk.Update(equity);

   double ddMoney = 0.0;
   const bool ok = risk.CheckDailyMaxDrawdownMoney(InpMaxDailyDDMoney, equity, ddMoney);

   if(!ok)
   {
      logg.Write(LOG_ERROR,
         "RISK BLOCK: MaxDailyDD hit. ddMoney=" + DoubleToString(ddMoney, 2)
      );

      if(InpKillMode == KILL_HARD)
      {
         CloseAllPositions();
      }

      return;
   }

   // No trading logic yet. This is only the risk layer wiring.
}


   
  void CloseAllPositions()
   {
      for(int i = PositionsTotal() - 1; i >= 0; i--)
      {
         ulong ticket = PositionGetTicket(i);
         if(ticket == 0) continue;
   
         if(PositionSelectByTicket(ticket))
         {
            string sym = PositionGetString(POSITION_SYMBOL);
            if(sym == _Symbol)
            {
               if(!trade.PositionClose(ticket))
                  logg.Write(LOG_ERROR, "Failed to close position ticket=" + (string)ticket);
               else
                  logg.Write(LOG_WARN, "Position closed due to HARD kill. ticket=" + (string)ticket);
            }
         }
      }
   }

