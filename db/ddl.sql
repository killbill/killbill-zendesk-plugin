CREATE TABLE `zendesk_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `kb_account_id` varchar(255) NOT NULL,
  `zd_user_id` bigint(11) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_zendesk_users_on_kb_account_id` (`kb_account_id`),
  UNIQUE KEY `index_zendesk_users_on_zd_user_id` (`zd_user_id`)
) ENGINE=InnoDB CHARACTER SET utf8 COLLATE utf8_bin;
