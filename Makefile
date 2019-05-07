prefix=''

filelist := $$(cat MANIFEST)

install: install_bin install_cron install_etc

install_cron:
	install -o root -g adm -m 0640 cron/borgbackup $(prefix)/etc/cron.d

install_etc:
	test -d $(prefix)/etc/logrotate.d || mkdir -p $(prefix)/etc/logrotate.d
	test -d $(prefix)/etc/borg || mkdir -p $(prefix)/etc/borg
	install -o root -g adm -m 0640 etc/logrotate.d/borgbackup $(prefix)/etc/logrotate.d
	install -o root -g adm -m 0640 etc/patterns $(prefix)/etc/borg
	install -o root -g adm -m 0640 etc/version $(prefix)/etc/borg
	mkdir --parents --mode=700 /var/log/backup

install_bin:
	test -d $(prefix)/root/bin || mkdir -p $(prefix)/root/bin
	for file in $(filelist); do \
		install -o root -g adm -m 0750 $$file $(prefix)/root/bin ; \
	done 

uninstall: uninstall_cron uninstall_bin uninstall_etc

uninstall_bin:
	for file in $(filelist); do \
		rm -f $(prefix)/root/$$file ; \
	done

uninstall_etc:
	-rm -f  $(prefix)/etc/logrotate.d/borgbackup
	-rm -rf $(prefix)/etc/borg

uninstall_cron:
	-rm -f $(prefix)/etc/cron.d/borgbackup

reinstall: uninstall install

.PHONY: install uninstall reinstall install_cron install_bin install_etc uninstall_etc gitrevchk

gitrevchk:
	cd /root/bin
	for file in $(filelist); do \
		cp /root/$$file bin ;\
	done
	cp /etc/logrotate.d/borgbackup etc/logrotate.d
	cp /etc/borg/patterns etc
	cp /etc/borg/version  etc
	cp /etc/cron.d/borgbackup cron

