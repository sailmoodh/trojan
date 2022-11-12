#!sh
apk update
apk add build-base perl linux-headers git
wget --no-check-certificate https://github.com/openssl/openssl/archive/OpenSSL_1_1_1s.tar.gz
tar xf OpenSSL_1_1_1s.tar.gz
cd openssl-OpenSSL_1_1_1s
./config --openssldir=/etc/ssl enable-ec_nistp_64_gcc_128 no-ssl2 no-ssl3 no-comp no-idea no-dtls no-dtls1 no-shared no-psk no-srp no-ec2m no-weak-ssl-ciphers
make install_sw
cd ..
rm -rf OpenSSL_1_1_1s.tar.gz openssl-OpenSSL_1_1_1s

wget https://github.com/Kitware/CMake/releases/download/v3.24.3/cmake-3.24.3.tar.gz
tar xf cmake-3.24.3.tar.gz
cd cmake-3.24.3
./bootstrap --
make install
cd ..
rm -rf cmake*

wget https://boostorg.jfrog.io/artifactory/main/release/1.80.0/source/boost_1_80_0.tar.gz
tar xf boost_1_80_0.tar.gz
cd boost_1_80_0
./bootstrap.sh
./b2 --with-system --with-program_options variant=release link=static threading=multi runtime-link=shared install
cd ..
rm -rf boost*

wget https://github.com/mariadb-corporation/mariadb-connector-c/archive/refs/tags/v3.3.2.tar.gz
tar xf v3.3.2.tar.gz
cd mariadb-connector-c-3.3.2
echo "TARGET_LINK_LIBRARIES(libmariadb PUBLIC pthread)" >> libmariadb/CMakeLists.txt
cmake -DWITH_CURL=OFF -DWITH_DYNCOL=OFF -DWITH_MYSQLCOMPAT=ON -DWITH_UNIT_TESTS=OFF .
make install
cd ..
rm -rf mariadb-connector-c-3.3.2 v3.3.2.tar.gz

git clone https://github.com/trojan-gfw/trojan.git
cd trojan
echo 'target_link_libraries(trojan dl)' >> CMakeLists.txt
cmake -DCMAKE_CXX_FLAGS="-static" -DMYSQL_INCLUDE_DIR=/usr/local/include/mariadb -DMYSQL_LIBRARY=/usr/local/lib/mariadb/libmysqlclient.a -DDEFAULT_CONFIG=config.json -DFORCE_TCP_FASTOPEN=ON -DBoost_USE_STATIC_LIBS=ON .
make
strip -s trojan
