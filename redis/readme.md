Best: install just Redis CLI with redis-cli binary from tarball

sudo apt-get update && sudo apt-get install libjemalloc1 libjemalloc-dev gcc make

cd downloads
wget http://download.redis.io/redis-stable.tar.gz
tar xvz redis-stable.tar.gz
cd redis-stable
make
make test
sudo cp src/redis-cli /usr/local/bin/
sudo chmod 755 /usr/local/bin/redis-cli

You’ll need libjemalloc1 libjemalloc-dev gcc make most of which should already be installed. We’re building from source… which takes about a minute on the CircleCI containers (so I would expect less everywhere else), which is fine.

Credit: DevOps Zone, install redis-cli without installing server. I shamelessly took the snippet from there, because hey, it works.