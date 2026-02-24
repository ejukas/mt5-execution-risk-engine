#ifndef EXEC_RISKENGINE_LOGGER_MQH
#define EXEC_RISKENGINE_LOGGER_MQH

enum LogLevel
{
   LOG_INFO = 0,
   LOG_WARN = 1,
   LOG_ERROR = 2
};

class Logger
{
private:
   bool     m_enabled;
   LogLevel m_minLevel;
   string   m_prefix;

   string LevelToStr(LogLevel lvl) const
   {
      switch(lvl)
      {
         case LOG_INFO:  return "INFO";
         case LOG_WARN:  return "WARN";
         case LOG_ERROR: return "ERROR";
      }
      return "UNK";
   }

public:
   Logger()
   {
      m_enabled  = true;
      m_minLevel = LOG_INFO;
      m_prefix   = "ExecRiskEngine";
   }

   void Configure(bool enabled, LogLevel minLevel, const string prefix)
   {
      m_enabled  = enabled;
      m_minLevel = minLevel;
      m_prefix   = prefix;
   }

   void Write(LogLevel lvl, const string msg)
   {
      if(!m_enabled) return;
      if(lvl < m_minLevel) return;

      Print(m_prefix, " [", LevelToStr(lvl), "] ", msg);
   }
};

#endif // EXEC_RISKENGINE_LOGGER_MQH
