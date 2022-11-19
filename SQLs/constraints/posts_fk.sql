alter table posts
drop constraint if exists fieldid_fk;

alter table posts
add constraint fieldid_fk foreign key (fieldid) references "Common".fields (fieldid)
on delete cascade;

alter table posts
add constraint fieldid_acc_ans_id_fk foreign key (fieldid,acceptedanswerid) references posts (fieldid,id);

alter table posts
add constraint fieldid_last_editor_id_fk foreign key (fieldid,lasteditoruserid) references users (fieldid,id);

alter table posts
add constraint fieldid_owner_id_fk foreign key (fieldid,owneruserid) references users (fieldid,id);

alter table posts
    drop constraint if exists fieldid_parent_id_fk;

alter table posts
add constraint fieldid_parent_id_fk foreign key (fieldid,parentid) references posts (fieldid,id)
on delete cascade;