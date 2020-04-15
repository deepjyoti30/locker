all: install

install:
	@echo "[*] Starting installation of locker"
	@echo "[*] Copying the binary to /usr/bin/"
	@cp locker.sh /usr/bin/locker
	@echo "[*] Setting permissions"
	@chmod go+x /usr/bin/locker
