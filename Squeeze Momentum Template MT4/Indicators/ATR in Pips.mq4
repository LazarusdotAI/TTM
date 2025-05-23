//+------------------------------------------------------------------+
//|                                                     ATR Pips.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Joshua Jones"
#property link      "http://www.forexfactory.com"

#property indicator_chart_window
#property indicator_buffers 1

//---- input parameters

extern int     periods = 1440;
extern double  multiplier = 1;
extern int     CommentCorner = 3;
extern int     xDistance=5;
extern int     yDistance=5;
extern color   LabelColor = Gray;
double buffer[];

string prefix = "";

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {

   
   SetIndexBuffer(0,buffer);
   SetIndexLabel(0,"ATR (" + periods + ")");
   SetIndexStyle(0,DRAW_NONE);
   IndicatorShortName(prefix + "ATR (" + periods + ")");
   
   if(ObjectFind("label_ATRinPips")==-1)
     ObjectCreate("label_ATRinPips", OBJ_LABEL, 0, 0, 0);
     
   ObjectSet("label_ATRinPips",OBJPROP_CORNER, CommentCorner);
   ObjectSet("label_ATRinPips", OBJPROP_XDISTANCE, xDistance);
   ObjectSet("label_ATRinPips", OBJPROP_YDISTANCE, yDistance);

//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
   if(ObjectFind("label_ATRinPips")!=-1) ObjectDelete("label_ATRinPips");
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+

int start()
  {
   int limit;  
   int counted_bars=IndicatorCounted(); 
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;

      double pipMult = 1/(_Point*MathPow(10,MathMod(_Digits,2)));
   limit=Bars-counted_bars;


      for (int i = 0; i < limit; i++){
         double stopLoss = MathCeil(pipMult * multiplier * (iATR(NULL,0,periods,i)));
         buffer[i] = stopLoss;
      }
      
      
      //Comment(prefix, "ATR (", periods, "): ", buffer[0], " pips");
      string text = prefix+ "ATR ("+ periods+ "): "+ DoubleToStr(buffer[0],0)+" pips";
      ObjectSetText("label_ATRinPips",text, 7, "Arial", LabelColor);
      
      return(0);
  }
//+------------------------------------------------------------------+