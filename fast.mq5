#include <Trade/Trade.mqh>

input ENUM_TIMEFRAMES timeframe=PERIOD_M5;
double lots=0.1;
double ask, bid;
double MACDMainLine[];
double MACDSignalLine[];
int MACDef;

CTrade trade;

int OnInit(){

   MACDef=iMACD(_Symbol,timeframe,12,26,9,PRICE_CLOSE);
   ArraySetAsSeries(MACDMainLine,true);
   ArraySetAsSeries(MACDSignalLine,true);

   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason){

}

void OnTick(){

   /*Strategy One= MACD Setup Detector
    MACD main line>0=Bullish Setup
    MACD main line<0=Bearish Setup
   */ 
   CopyBuffer(MACDef,0,0,3,MACDMainLine);
   CopyBuffer(MACDef,1,0,3,MACDSignalLine);
   
   double MACDMainLineVal=(MACDMainLine[0]);
   double MACDSignalLineVal=(MACDSignalLine[0]);
   
   ask=SymbolInfoDouble(_Symbol,SYMBOL_ASK);
   bid=SymbolInfoDouble(_Symbol,SYMBOL_BID);
   
   if(OrdersTotal()==0){
      /*
      if (MACDMainLineVal > 0) {
         // Configuración alcista (COMPRA)
         Comment("Señal Alcista");
         double sl = ask - 0.00025;
         double tp = ask + 0.0005;
         bool result = trade.Buy(lots, _Symbol, ask, sl, tp);
         if (result) {
            Print("Orden de compra ejecutada con éxito");
         } else {
            int error = GetLastError();
            Print("Error al ejecutar la orden de compra: ", error);
            ResetLastError();
         }
      } else if (MACDMainLineVal < 0) {
         // Configuración bajista (VENTA)
         Comment("Señal Bajista");
         double sl = bid + 0.00025;
         double tp = bid - 0.0005;
         bool result = trade.Sell(lots, _Symbol, bid, sl, tp);
         if (result) {
            Print("Orden de venta ejecutada con éxito");
         } else {
            int error = GetLastError();
            Print("Error al ejecutar la orden de venta: ", error);
            ResetLastError();
         }
      }
      */
      
      /*Strategy Two= MACD Lines Crossover
      MACD main line>MACD signal line=Buying Signal
      MACD main line<MACD signal line=Shortin Signal
      */
      /*
      if (MACDMainLineVal>0 && MACDSignalLineVal>0 && MACDMainLineVal > MACDSignalLineVal) {
         // Señal de COMPRA
         double sl = ask - 0.00025;
         double tp = ask + 0.0004;
         bool result = trade.Buy(lots, _Symbol, ask, sl, tp);
         if (result) {
            Print("Orden de compra ejecutada con éxito");
         } else {
            int error = GetLastError();
            Print("Error al ejecutar la orden de compra: ", error);
            ResetLastError();
         }
      }
      */
      if (MACDMainLineVal<0 && MACDSignalLineVal>0 && MACDMainLineVal < MACDSignalLineVal) {
         // Señal de VENTA
         double sl = bid + 0.00025;
         double tp = bid - 0.0004;
         bool result = trade.Sell(lots, _Symbol, bid, sl, tp);
         if (result) {
            Print("Orden de venta ejecutada con éxito");
         } else {
            int error = GetLastError();
            Print("Error al ejecutar la orden de venta: ", error);
            ResetLastError();
         }
      }
   }
}