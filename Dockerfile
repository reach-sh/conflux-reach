FROM debian:buster-slim as build

RUN apt-get update; apt-get install clang libsqlite3-dev pkg-config libssl-dev cmake curl git openssl -y
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > /rustup.sh
RUN chmod +x /rustup.sh
RUN /rustup.sh -y
RUN /root/.cargo/bin/rustup install 1.47.0
RUN git clone https://github.com/reach-sh/conflux-reach.git
WORKDIR conflux-reach
RUN git checkout v1.1.0-reach
RUN /root/.cargo/bin/cargo build --release
RUN cp ./target/release/conflux ./run/conflux

FROM debian:buster-slim

COPY --from=build /conflux-reach/target/release/conflux /
COPY reach-cfx/log.yaml reach-cfx/default.toml reach-cfx/genesis_secret.txt reach-cfx/run.sh /