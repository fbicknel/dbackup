prefix=/root

filelist := $$(cat MANIFEST)

install: install_bin install_cron 

install_cron:
	crontab -l | sed -e '/###@duplicity@###/d'| sed -e '$$a@daily nice -n 19 /root/bin/dbackup >> /var/log/backup/dbackup.out 2>&1 ###@duplicity@###' | crontab -

uninstall_cron:
	crontab -l | sed -e '/###@duplicity@###/d'| crontab -

install_bin:
	test -d $(prefix) || mkdir -p $(prefix)/bin
	for file in $(filelist); do \
		install -m 0755 $$file $(prefix)/bin ; \
	done 

uninstall: uninstall_cron uninstall_bin

uninstall_bin:
	for file in $(filelist); do \
		rm $(prefix)/$$file ; \
	done
	rmdir $(prefix)/bin

reinstall: uninstall install

.PHONY: install uninstall reinstall install_cron install_bin
