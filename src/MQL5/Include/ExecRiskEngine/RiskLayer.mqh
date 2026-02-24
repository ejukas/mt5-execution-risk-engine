#ifndef EXEC_RISKENGINE_RISKLAYER_MQH
#define EXEC_RISKENGINE_RISKLAYER_MQH

#define __RISK_LAYER_INCLUDED__ 1


class RiskLayer
{
private:
   datetime m_dayKey;
   double   m_equityStart;
   double   m_equityPeak;
   bool     m_blockTrading;

   datetime DayKey(datetime t) const
   {
      // "chave" do dia para resetar quando virar a data
      MqlDateTime dt;
      TimeToStruct(t, dt);
      dt.hour = 0; dt.min = 0; dt.sec = 0;
      return StructToTime(dt);
   }

public:
   RiskLayer()
   {
      m_dayKey       = 0;
      m_equityStart  = 0.0;
      m_equityPeak   = 0.0;
      m_blockTrading = false;
   }

   void ResetForNewDay(double currentEquity)
   {
      m_equityStart  = currentEquity;
      m_equityPeak   = currentEquity;
      m_blockTrading = false;
   }

   // Call on every tick (or timer) to keep state updated
   void Update(double currentEquity)
   {
      datetime nowKey = DayKey(TimeCurrent());
      if(m_dayKey == 0)
      {
         m_dayKey = nowKey;
         ResetForNewDay(currentEquity);
         return;
      }

      if(nowKey != m_dayKey)
      {
         m_dayKey = nowKey;
         ResetForNewDay(currentEquity);
         return;
      }

      if(currentEquity > m_equityPeak)
         m_equityPeak = currentEquity;
   }

   bool CheckDailyMaxDrawdownMoney(double maxDdMoney, double currentEquity, double &outDdMoney)
   {
      outDdMoney = m_equityPeak - currentEquity;

      if(maxDdMoney <= 0.0)
         return true; // disabled

      if(outDdMoney >= maxDdMoney)
      {
         m_blockTrading = true;
         return false;
      }

      return !m_blockTrading;
   }

   bool IsBlocked() const { return m_blockTrading; }

   double EquityStart() const { return m_equityStart; }
   double EquityPeak()  const { return m_equityPeak; }
};
#endif // EXEC_RISKENGINE_RISKLAYER_MQH
