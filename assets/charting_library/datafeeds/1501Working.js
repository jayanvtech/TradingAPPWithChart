


const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiJBMDg4Nl9hMzgzMTAyYzljODg1ODRhYjYxNDQ3IiwicHVibGljS2V5IjoiYTM4MzEwMmM5Yzg4NTg0YWI2MTQ0NyIsImlhdCI6MTczMDgwMDA3NCwiZXhwIjoxNzMwODg2NDc0fQ.Oyd3L425SWCT0gLKVnmHIDiRxK_onLhqz4hj_uR0gZY"; // Replace with your token
const userID = "A0031"; // Replace with your user ID
const socket = io('https://mtrade.arhamshare.com', {
    path: "/apimarketdata/socket.io",
    transports: ['websocket'],
    query: {
        token,
        userID,
        publishFormat: "JSON",
        broadcastMode: "Full",
        apiType: "APIMARKETDATA",
    },
});

socket.on('connect', () => {
    console.log('Socket connected successfully');
});
socket.on('1501-json-full', (dsd) => {
  console.log('----------- Socket 1505-json-full',dsd);
});
socket.on('disconnect', (dsd) => {
    console.log('----------- Socket disconnected',dsd);
});


function addYearsToTimestamp(timestamp, years) {
  const date = new Date(timestamp);
  date.setFullYear(date.getFullYear() + years);

  // Subtract one day
  date.setDate(date.getDate() - 1);

  return date.getTime();
}

// Example usage:
const timestamp = 1415276107000; // January 1, 2021
const newTimestamp = addYearsToTimestamp(timestamp, 10);

console.log(new Date(timestamp)); // Original date
console.log(new Date(newTimestamp));

// This function will handle the incoming candle data
function processIncomingData(data) {
  const parsedData = JSON.parse(data); // Parse the incoming JSON string
  const ExchangeTimeStampss = Number(parsedData.ExchangeTimeStamp) * 1000;
   const ExchangeTimeStamp = addYearsToTimestamp(ExchangeTimeStampss,10) ;// Convert to milliseconds
  if (isNaN(ExchangeTimeStamp)) {
      console.error("Invalid LastTradedTime:", parsedData.ExchangeTimeStamp);
      return; // Exit if LastTradedTime is invalid
  }


  return {
    time: ExchangeTimeStamp,
    open: parseFloat(parsedData.Touchline.Open),
    high: parseFloat(parsedData.Touchline.High),
    low: parseFloat(parsedData.Touchline.Low),
    close: parseFloat(parsedData.Touchline.LastTradedPrice),
    volume: parseInt(parsedData.Touchline.TotalTradedQuantity, 10),
  };
}
  export default {
    onReady: (callback) => {
      const supportedResolutions = ["1", "5", "15", "30", "60", "D", "W"];
      setTimeout(() => callback({ supported_resolutions: supportedResolutions }), 0);
    },

    resolveSymbol: (symbolName, onSymbolResolvedCallback, onResolveErrorCallback) => {
      const symbolInfo = {
        name: '2885',
        type: "stock",
        session: "0930-1530",
        timezone: "Europe/London",
        exchange: "NSE",
        minmov: 1,
        pricescale: 100,
        has_intraday: true,
        supported_resolutions: ["1", "5", "15", "30", "60", "D", "W"],
      };
      onSymbolResolvedCallback(symbolInfo);
    },

    getBars: async (
      symbolInfo,
      resolution,
      periodParams,
      onHistoryCallback,
      onErrorCallback = (error) => console.error("Error fetching bars:", error)
    ) => {
      console.log("periodParams:", periodParams);
      console.log("[getBars]: Method call", symbolInfo);
      const currentTime = new Date();
      const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      const formattedDate = `${monthNames[currentTime.getMonth()]} ${String(currentTime.getDate()).padStart(2, '0')} ${currentTime.getFullYear()} ${String(currentTime.getHours()).padStart(2, '0')}${String(currentTime.getMinutes()).padStart(2, '0')}${String(currentTime.getSeconds()).padStart(2, '0')}`;
      // const url = `https://mtrade.arhamshare.com/marketdata/instruments/ohlc?exchangeSegment=1&exchangeInstrumentID=26000&startTime=Jul 01 2024 091500&endTime=${formattedDate}&compressionValue=60`
      // console.log("formattedDate:", url);
const url= 'http://192.168.119.199:3008/api/v1/ohlc';
      try {
        const response = await fetch(url,
          {
            headers: {
              Authorization:
                "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiJBMDg4Nl9hMzgzMTAyYzljODg1ODRhYjYxNDQ3IiwicHVibGljS2V5IjoiYTM4MzEwMmM5Yzg4NTg0YWI2MTQ0NyIsImlhdCI6MTczMDY5MzExOSwiZXhwIjoxNzMwNzc5NTE5fQ.PevpDUvlOMAta-H1M79FP5V35t2xRCcn0VbjXaN75dg", // Replace with your token
            },
          }
        );

        if (response.status === 200) {
          const jsonResponse = await response.json();
          const dataResponse = jsonResponse.result.dataReponse;
          const rawData = dataResponse.split(",");

          const bars = rawData.map((item) => {
            const [timestamp, open, high, low, close, volume] = item.split("|");
            return {
              time: Number(timestamp) * 1000,
              open: parseFloat(open),
              high: parseFloat(high),
              low: parseFloat(low),
              close: parseFloat(close),
              volume: parseInt(volume),
            };
          });

          if (bars.length > 0) {
            onHistoryCallback(bars, { noData: false });
          } else {
            onHistoryCallback([], { noData: true });
          }
        } else {
          onHistoryCallback([], { noData: true });
        }
      } catch (error) {
        console.error("[getBars] Error:", error);
        if (typeof onErrorCallback === "function") {
          onErrorCallback(error);
        }
      }
    },

    subscribeBars: (symbolInfo, resolution, onRealtimeCallback, subscriberUID, onResetCacheNeededCallback) => {
      const subscribeMessage = {
          action: 'subscribe',
          symbol: symbolInfo.name,
          resolution: resolution,
      };
      
     // socket.emit('1505-json-full', subscribeMessage);

      socket.on('1501-json-full', (data) => {
          const bar = processIncomingData(data);
          onRealtimeCallback(bar);
      });
  },

    unsubscribeBars: (subscriberUID) => {
      // Unsubscribe logic
    }

  };