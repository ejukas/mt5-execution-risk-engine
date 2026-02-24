#property strict
#property version   "0.1.0"
#property description "MT5 Execution & Risk Control Engine - sample EA wiring"

#include <Trade/Trade.mqh>
#include <ExecRiskEngine\RiskLayer.mqh>

CTrade trade;

input double InpMaxDailyDDMoney = 50.0; // daily max drawdown in account currency (0=disabled)

RiskLayer risk;
#ifndef __RISK_LAYER_INCLUDED__
   #error "RiskLayer.mqh was not included"
#endif

int OnInit()
{
   const long login = AccountInfoInteger(ACCOUNT_LOGIN);
   Print("ExecRiskEngine v0.1.0 loaded. Login=", login);

   risk.Update(AccountInfoDouble(ACCOUNT_EQUITY));
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
      Print("RISK BLOCK: MaxDailyDD hit. ddMoney=", DoubleToString(ddMoney, 2),
            " peak=", DoubleToString(risk.EquityPeak(), 2),
            " equity=", DoubleToString(equity, 2),
            " limit=", DoubleToString(InpMaxDailyDDMoney, 2));
      return;
   }

   // No trading logic yet. This is only the risk layer wiring.
}

