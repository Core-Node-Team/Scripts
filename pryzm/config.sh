
BinaryName="pryzmd"
DirectName=".pryzm" #database directory
CustomPort="316"
NodeName="pryzm"  # project folder
ChainID="indigo-1"

install_binary() {
print_color $Blue "$BinaryName Kuruluyor..."
sleep 1
exec > /dev/null 2>&1
cd $HOME
wget https://storage.googleapis.com/pryzm-resources/pryzmd-0.9.0-linux-amd64.tar.gz
tar -xzvf pryzmd-0.9.0-linux-amd64.tar.gz
mv pryzmd $HOME/go/bin
source $HOME/.bash_profile
exec > /dev/tty 2>&1
source $HOME/.bash_profile
print_color $Yellow "$BinaryName $($BinaryName version) Kuruldu."
sleep 1
}

snapshot() {
print_color $Blue "Snapshot İndiriliyor..."
curl -L http://37.120.189.81/pryzm_testnet/pryzm_snap.tar.lz4 | tar -I lz4 -xf - -C $HOME/.pryzm/data
}

config() {
print_color $Blue "Yapılandırma Dosyası Ayarları Yapılıyor..."
exec > /dev/null 2>&1
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/pryzm/addrbook.json > $HOME/$DirectName/config/addrbook.json
curl -Ls https://raw.githubusercontent.com/Core-Node-Team/scripts/main/pryzm/genesis.json > $HOME/$DirectName/config/genesis.json
peers="713307ce72306d9e86b436fc69a03a0ab96b678f@pryzm-testnet-peer.itrocket.net:41656,4af5be7666e9ee756a9a588c181f9631064b9cf8@37.27.55.69:26656,5d9bcb33eef94e045fe51105c89f5d77709b3183@144.76.101.167:5000,9515a13bbdeb233eb59efd6e8db892ac46e5bac5@142.132.153.6:56656,f9ade689abb3c59d3e3d8edf26c65bde3db58676@116.202.85.52:35656,7397a1bcbf413b76bd710fcf363f8259acdc4d29@144.91.84.168:23256,db0e0cff276b3292804474eb8beb83538acf77f5@195.14.6.192:26656,794b538577a59f789ce942fd393730da3e8c0ffe@34.65.224.175:26656,565e54f6b12672fba48861fc72654c39dc0f2d97@195.3.223.138:36656,cdcd86ca01858275d0e78ee66b82109ee06df454@65.108.72.253:40656,2c7bb6ad931b0b2b24a0d8e6b7b5e0636b8bafb0@38.242.230.118:48656"
seeds="fbfd48af73cd1f6de7f9102a0086ac63f46fb911@pryzm-testnet-seed.itrocket.net:41656"
sed -i -e 's|^seeds *=.*|seeds = "'$seeds'"|; s|^persistent_peers *=.*|persistent_peers = "'$peers'"|' $HOME/$DirectName/config/config.toml
sed -i -e "s|^minimum-gas-prices *=.*|minimum-gas-prices = \"0.015upryzm\"|" $HOME/.pryzm/config/app.toml
sed -i -e "s/prometheus = false/prometheus = true/" $HOME/.pryzm/config/config.toml



# puruning
sed -i \
  -e 's|^pruning *=.*|pruning = "custom"|' \
  -e 's|^pruning-keep-recent *=.*|pruning-keep-recent = "100"|' \
  -e 's|^pruning-keep-every *=.*|pruning-keep-every = "0"|' \
  -e 's|^pruning-interval *=.*|pruning-interval = "10"|' \
  $HOME/$DirectName/config/app.toml
# indexer
sed -i -e 's|^indexer *=.*|indexer = "null"|' $HOME/$DirectName/config/config.toml
# custom port
sed -i -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${CustomPort}58\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${CustomPort}57\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${CustomPort}60\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${CustomPort}56\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${CustomPort}66\"%" $HOME/$DirectName/config/config.toml
sed -i -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${CustomPort}17\"%; s%^address = \":8080\"%address = \":${CustomPort}80\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${CustomPort}90\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${CustomPort}91\"%; s%:8545%:${CustomPort}45%; s%:8546%:${CustomPort}46%; s%:6065%:${CustomPort}65%" $HOME/$DirectName/config/app.toml
sed -i -e "s%^address = \"tcp://localhost:1317\"%address = \"tcp://localhost:${CustomPort}17\"%; s%^address = \":8080\"%address = \":${CustomPort}80\"%; s%^address = \"localhost:9090\"%address = \"localhost:${CustomPort}90\"%; s%^address = \"localhost:9091\"%address = \"localhost:${CustomPort}91\"%; s%:8545%:${CustomPort}45%; s%:8546%:${CustomPort}46%; s%:6065%:${CustomPort}65%" $HOME/$DirectName/config/app.toml
exec > /dev/tty 2>&1
sleep 1
print_color $Yellow "Tamamlandı."
sleep 1
}





