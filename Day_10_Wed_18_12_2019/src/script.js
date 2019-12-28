function log(logstr) {   
    document.getElementById("log").innerHTML +=logstr+"\n";
}

async function addFile() {
    var str=document.getElementById("stringtoadd").value; // note: trailing space, CR, LF
    const Buffer=window.buffer.Buffer;
    const ipfs = window.IpfsHttpClient('https://ipfs.infura.io:5001');         
    const bufDataToHash = Buffer.from(str);
    log(`Adding ${str} to ipfs via Infura`);
    const hash=await ipfs.add(bufDataToHash).catch(console.log); 
    log(`Hash ${hash[0].hash}`);
}

async function retrieveFile() {
    var hash= document.getElementById("hashtoretrieve").value;
    const ipfs = window.IpfsHttpClient('https://ipfs.infura.io:5001');         
    log(`Checking hash ${hash} via Infura`)
    const file = await ipfs.cat(hash).catch(x=> log(`Error ${x}`));
    if (file)
        log(file.toString('utf8'));
}