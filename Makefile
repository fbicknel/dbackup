prefix=''

filelist := $$(cat MANIFEST)

install: install_bin install_cron install_etc

install_cron:
	crontab -l | sed -e '/###@duplicity@###/d'| sed -e '$$a30 0 * * * nice -n 19 /root/bin/dbackup >> /var/log/backup/dbackup.out 2>&1 ###@duplicity@###' | crontab -

uninstall_cron:
	crontab -l | sed -e '/###@duplicity@###/d'| crontab -

install_etc:
	test -d $(prefix)/etc/logrotate.d || mkdir -p $(prefix)/etc/logrotate.d
	install -m 0755 etc/logrotate.d/dbackup $(prefix)/etc/logrotate.d

install_bin:
	test -d $(prefix)/root/bin || mkdir -p $(prefix)/root/bin
	for file in $(filelist); do \
		install -m 0755 $$file $(prefix)/root/bin ; \
	done 

uninstall: uninstall_cron uninstall_bin uninstall_etc

uninstall_bin:
	for file in $(filelist); do \
		rm -f $(prefix)/root/$$file ; \
	done

uninstall_etc:
	-rm -f $(prefix)/etc/logrotate.d/dbackup

reinstall: uninstall install

.PHONY: install uninstall reinstall install_cron install_bin install_etc uninstall_etc
