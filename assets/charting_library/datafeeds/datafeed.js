
// const token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiJBMDg4Nl9hMzgzMTAyYzljODg1ODRhYjYxNDQ3IiwicHVibGljS2V5IjoiYTM4MzEwMmM5Yzg4NTg0YWI2MTQ0NyIsImlhdCI6MTczMTkwOTEwOCwiZXhwIjoxNzMxOTk1NTA4fQ.9dTEStlVYIC4cC2Kea77dQWaWzDbYUwq6ERv6P5Fl8g"; // Replace with your token
// const userID = "A0031"; // Replace with your user ID
// const socket = io('https://mtrade.arhamshare.com', {
//     path: "/apimarketdata/socket.io",
//     transports: ['websocket'],
//     query: {
//         token,
//         userID,
//         publishFormat: "JSON",
//         broadcastMode: "Full",
//         apiType: "APIMARKETDATA",
//     },
// });


// socket.on('connect', () => {  
//     console.log('Socket connected successfully');
// });

// socket.on('1505-json-full', (dsd) => {
//   console.log('----------- Socket 1505-json-full',dsd);
// });
// socket.on('disconnect', (dsd) => {
//     console.log('----------- Socket disconnected',dsd);
// });
// // This function will handle the incoming candle data
// function processIncomingData(data) {
//   const parsedData = JSON.parse(data); // Parse the incoming JSON string
//   const barTime = Number(parsedData.BarTime) * 1000; // Convert to milliseconds
//   if (isNaN(barTime)) {
//       console.error("Invalid BarTime:", parsedData.BarTime);
//       return; // Exit if BarTime is invalid
//   }

//   return {
//       time: barTime,
//       open: parseFloat(parsedData.Open),
//       high: parseFloat(parsedData.High),
//       low: parseFloat(parsedData.Low),
//       close: parseFloat(parsedData.Close),
//       volume: parseInt(parsedData.BarVolume, 10),
//   };
// }
const userID = "A0031"; // Replace with your user ID
 const Exchange = window.Exchange;
let socket;
function initializeSocket(authToken, userID) {
  if (socket) {
      socket.close(); // Close existing socket connection if any
  }

  socket = io('https://mtrade.arhamshare.com/', {
      path: "/apimarketdata/socket.io",
      transports: ['websocket'],
      query: {
          token: authToken,
          userID,
          publishFormat: "JSON",
          broadcastMode: "Full",
          apiType: "APIMARKETDATA",
      },
  });

  socket.on('connect', () => {
      console.log('Socket connecteffd successfully');
  });

  socket.on('1505-json-full', (dsd) => {
      console.log('----------- Socket 1505-json-full', dsd);
  });

  socket.on('disconnect', (dsd) => {
      console.log('----------- Socket disconnected', dsd);
  });
}

  export default {
    initializeSocket,

    // initializeSocket: (authToken, userID) => {
    //   if (socket) socket.close(); // Close any existing socket connection
    // },  
    onReady: (callback) => {
      
      const supportedResolutions = ["1", "5", "15", "30", "60", "D", "W"];
      setTimeout(() => callback({ supported_resolutions: supportedResolutions }), 0);
    },
    
    resolveSymbol: (symbolName, onSymbolResolvedCallback, onResolveErrorCallback) => {
      const Exchange = window.Exchange;
      console.log("Using Exchange Exchange:=======", Exchange);
      const symbolInfo = {
         name: window.SymbolName || symbolName,
        type: "stock",
        session: "0915-1530",
        timezone: "Europe/London",
        exchange:  Exchange || "NSE",
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
      const url = `http://192.168.119.185:3008/api/v1/ohlc/get-ohlc?exchangeSegment=1&exchangeInstrumentID=26000&startTime=Jul 01 2024 091500&endTime=${formattedDate}&compressionValue=60`
    //  const url ='http://192.168.119.185:3008/api/v1/ohlc/get-ohlc';
      console.log("formattedDate:=====", formattedDate);
      console.log("URLformattedDate:=====", url);
      const authToken = window.authToken;
      console.log("Using auth token:", authToken);
      try {
        const response = await fetch(url,

          {
            headers: {
              Authorization: authToken,
            //   Authorization:
            //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiJBMDg4Nl9hMzgzMTAyYzljODg1ODRhYjYxNDQ3IiwicHVibGljS2V5IjoiYTM4MzEwMmM5Yzg4NTg0YWI2MTQ0NyIsImlhdCI6MTczMTkwOTEwOCwiZXhwIjoxNzMxOTk1NTA4fQ.9dTEStlVYIC4cC2Kea77dQWaWzDbYUwq6ERv6P5Fl8g", // Replace with your token
            // },
            }
          }
        );

        if (response.status === 200) {
          const jsonResponse = await response.json();
         
          const dataReponse = jsonResponse.data.result.dataReponse;
          console.log("dataReponse======:", dataReponse);
          const rawData = dataReponse.split(",")
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

      socket.on('1505-json-full', (data) => {
          const bar = processIncomingData(data);
          onRealtimeCallback(bar);
      });
  },

    unsubscribeBars: (subscriberUID) => {
      // Unsubscribe logic
    }

  };