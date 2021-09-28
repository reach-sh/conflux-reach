FROM debian:buster-slim as build

RUN apt-get update; apt-get install clang libsqlite3-dev pkg-config libssl-dev cmake curl git openssl -y
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /rustup.sh
RUN chmod +x /rustup.sh
RUN /rustup.sh -y
RUN /root/.cargo/bin/rustup install 1.47.0
#RUN git clone https://github.com/Conflux-Chain/conflux-rust
WORKDIR conflux-rust
#RUN git checkout v1.1.0
RUN /root/.cargo/bin/cargo build --release
RUN cp ./target/release/conflux ./run/conflux

FROM debian:buster-slim

COPY --from=build /conflux-rust/target/release/conflux /