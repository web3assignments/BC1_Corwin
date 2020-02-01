function log(logstr) {   
    document.getElementById("log").innerHTML +=logstr+"\n";
}

const ipfs = window.IpfsHttpClient('https://ipfs.infura.io:5001');

async function addFile() {
    let fileFormats = [];
    let ipfsId;
    const files = document.querySelector('[type=file]').files;
        
        for (let i = 0; i < files.length; i++) {
            let file = files[i];
            const fileformat = {
                path: file.name,
                content: file
            };
            fileFormats[i] = fileformat;
        }

        console.log(fileFormats);

        const options = {
            wrapWithDirectory: true,
            progress: (prog) => console.log(`received: ${prog}`)
        };

        ipfs.add(fileFormats, options).then((response) => {
            console.log(response);
            ipfsId = response[response.length - 1].hash;
            log(`The hash for the file is: ${ipfsId}`);
        }).catch((err) => {
            console.error(err);
        });    
}

async function retrieveFile() {
    var hash= document.getElementById("hashtoretrieve").value;         
    log(`ipfs.io/ipfs/${hash}`)  
}
