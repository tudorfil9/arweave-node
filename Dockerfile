 ### ARWEAVE ####
 # file: Dockerfile
# Use the official image as a parent image.
FROM ubuntu:latest
ENV OTP_VERSION="22.3.4.15" \
    REBAR3_VERSION="3.14.3"
LABEL org.opencontainers.image.version=$OTP_VERSION    
# Update and prep
RUN set -xe \
	&& OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
	&& OTP_DOWNLOAD_SHA256="05d388ee252fd04a8e9e62f3ea7be3b45a19f698d978452933a21138a383e80d" \
	&& runtimeDeps='libodbc1 \
			libsctp1 \
			libwxgtk3.0' \
	&& buildDeps='unixodbc-dev \
			libsctp-dev \
			libwxgtk3.0-dev' \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends $runtimeDeps \
	&& apt-get install -y --no-install-recommends $buildDeps \
	&& curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
	&& echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - \
	&& export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
	&& mkdir -vp $ERL_TOP \
	&& tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
	&& rm otp-src.tar.gz \
	&& ( cd $ERL_TOP \
	  && ./otp_build autoconf \
	  && gnuArch="$(dpkg-architecture --query DEB_HOST_GNU_TYPE)" \
	  && ./configure --build="$gnuArch" \
	  && make -j$(nproc) \
	  && make install ) \
	&& find /usr/local -name examples | xargs rm -rf \
	&& apt-get purge -y --auto-remove $buildDeps \
	&& rm -rf $ERL_TOP /var/lib/apt/lists/*

CMD ["erl"]
# Set the working directory.

ENV REBAR_VERSION="2.6.4"

RUN set -xe \
	&& REBAR_DOWNLOAD_URL="https://github.com/rebar/rebar/archive/${REBAR_VERSION}.tar.gz" \
	&& REBAR_DOWNLOAD_SHA256="577246bafa2eb2b2c3f1d0c157408650446884555bf87901508ce71d5cc0bd07" \
	&& mkdir -p /usr/src/rebar-src \
	&& curl -fSL -o rebar-src.tar.gz "$REBAR_DOWNLOAD_URL" \
	&& echo "$REBAR_DOWNLOAD_SHA256 rebar-src.tar.gz" | sha256sum -c - \
	&& tar -xzf rebar-src.tar.gz -C /usr/src/rebar-src --strip-components=1 \
	&& rm rebar-src.tar.gz \
	&& cd /usr/src/rebar-src \
	&& ./bootstrap \
	&& install -v ./rebar /usr/local/bin/ \
	&& rm -rf /usr/src/rebar-src

RUN set -xe \
	&& REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
	&& REBAR3_DOWNLOAD_SHA256="69024b30f17b52c61e5e0568cbf9a2db325eb646ae230c48858401507394f5c0" \
	&& mkdir -p /usr/src/rebar3-src \
	&& curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
	&& echo "$REBAR3_DOWNLOAD_SHA256 rebar3-src.tar.gz" | sha256sum -c - \
	&& tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
	&& rm rebar3-src.tar.gz \
	&& cd /usr/src/rebar3-src \
	&& HOME=$PWD ./bootstrap \
	&& install -v ./rebar3 /usr/local/bin/ \
	&& rm -rf /usr/src/rebar3-src
 
 
WORKDIR /appl/arweave

# Clone the arweave Repo
#RUN wget -q https://github.com/ArweaveTeam/arweave/releases/download/N.2.1.0.2/arweave-2.1.0.2.linux-x86_64.tar.gz && tar -zxf arweave-2.1.0.2.linux-x86_64.tar.gz

RUN wget -q https://arweave.net/Qs3pcYEvkzwi-R6AjrwfZ5WfDHpyk838QXcDRizVJZs && tar -zxf Qs3pcYEvkzwi-R6AjrwfZ5WfDHpyk838QXcDRizVJZs

WORKDIR /appl/arweave/bin/

RUN git clone https://github.com/tudorfil9/arweave-node.git /appl/arweave-node && cp /appl/arweave-node/start_w_epmd.sh .

RUN chmod +x start_w_epmd.sh

ARG AR_RUNMODE="test"

ENV AR_RUNMODE=${AR_RUNMODE}

ENTRYPOINT ./start_w_epmd.sh -r $AR_RUNMODE

# Add metadata to the image to describe which port the container is listening on at runtime.
EXPOSE 1984


