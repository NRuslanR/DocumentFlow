create table doc.charge_types(
id serial primary key,
name varchar not null,
service_name varchar not null
);

insert into doc.charge_types (name, service_name) values ('исполнение', 'performing'), ('ознакомление', 'acquaitance');

ALTER TABLE doc.service_note_receivers ADD COLUMN charge_type_id integer;

update doc.service_note_receivers set charge_type_id = (select id from doc.charge_types where service_name = 'performing');
ALTER TABLE doc.service_note_receivers
  ADD CONSTRAINT service_note_receivers_charge_type_id_fkey FOREIGN KEY (charge_type_id)
      REFERENCES doc.charge_types (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
      
ALTER TABLE doc.service_note_receivers ALTER COLUMN charge_type_id SET NOT NULL;
