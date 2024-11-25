const configurationData = {
    // Represents the resolutions for bars supported by your datafeed
    supported_resolutions: ['1D', '1W', '1M'],
    // The `exchanges` arguments are used for the `searchSymbols` method if a user selects the exchange
    exchanges: [
        { value: 'Bitfinex', name: 'Bitfinex', desc: 'Bitfinex' },
        { value: 'Kraken', name: 'Kraken', desc: 'Kraken bitcoin exchange' },
    ],
    // The `symbols_types` arguments are used for the `searchSymbols` method if a user selects this symbol type
    symbols_types: [
        { name: 'crypto', value: 'crypto' }
    ]
};

onReady: (callback) => {
    console.log('[onReady]: Method call');
    setTimeout(() => callback(configurationData));
}

const handleApi = async () => {
    try {
        const response = await fetch('https://mtrade.arhamshare.com/marketdata/instruments/ohlc?exchangeSegment=1&exchangeInstrumentID=2885&startTime=Nov 01 2024 091500&endTime=Nov 30 2024 153000&compressionValue=60',
            {
                headers: {
                    Authorization: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySUQiOiJBMDg4Nl9hMzgzMTAyYzljODg1ODRhYjYxNDQ3IiwicHVibGljS2V5IjoiYTM4MzEwMmM5Yzg4NTg0YWI2MTQ0NyIsImlhdCI6MTczMDY5MzExOSwiZXhwIjoxNzMwNzc5NTE5fQ.PevpDUvlOMAta-H1M79FP5V35t2xRCcn0VbjXaN75dg",
                }
            }
        );
        console.log("sdsdsdsdResponse", response);
        if (response.status === 200) {
            const data = await response.json();
            console.log("Response", data.result.dataReponse);
            localStorage.setItem('apiData', JSON.stringify(data.result.dataReponse));
        } else {
            console.log("Error");
        }
    } catch (error) {
        console.log(error);
    }
};

// To retrieve the stored data
const storedData = JSON.parse(localStorage.getItem('apiData'));
console.log("Stored Data:", storedData);
