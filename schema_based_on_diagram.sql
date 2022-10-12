-- Table: public.treatments

-- DROP TABLE IF EXISTS public.treatments;

CREATE TABLE IF NOT EXISTS public.treatments
(
    id integer NOT NULL,
    type character varying COLLATE pg_catalog."default",
    name character varying COLLATE pg_catalog."default",
    CONSTRAINT treatments_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.treatments
    OWNER to postgres;
CREATE TABLE IF NOT EXISTS public.patients
(
    id integer NOT NULL,
    name character varying COLLATE pg_catalog."default" NOT NULL,
    date_of_birth date NOT NULL,
    CONSTRAINT patients_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.patients
    OWNER to postgres;
	
CREATE TABLE IF NOT EXISTS public.medical_histories
(
    id integer NOT NULL,
    admitted_at timestamp without time zone,
    patient_id integer,
    status character varying COLLATE pg_catalog."default",
    CONSTRAINT medical_histories_pkey PRIMARY KEY (id),
    CONSTRAINT id FOREIGN KEY (id)
        REFERENCES public.treatments (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT patient_id FOREIGN KEY (patient_id)
        REFERENCES public.patients (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.medical_histories
    OWNER to postgres;
	
CREATE TABLE IF NOT EXISTS public.invoices
(
    id integer NOT NULL,
    total_amount numeric,
    generated_at timestamp without time zone,
    payed_at timestamp without time zone,
    medical_history_id integer,
    CONSTRAINT invoices_pkey PRIMARY KEY (id),
    CONSTRAINT medical_history_id FOREIGN KEY (medical_history_id)
        REFERENCES public.medical_histories (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.invoices
    OWNER to postgres;

CREATE TABLE IF NOT EXISTS public.invoice_items
(
    id integer NOT NULL,
    unit_price numeric,
    quantity integer,
    total_price numeric,
    invoice_id integer,
    treatment_id integer,
    CONSTRAINT invoice_items_pkey PRIMARY KEY (id),
    CONSTRAINT invoice_id FOREIGN KEY (invoice_id)
        REFERENCES public.invoices (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT treatment_id FOREIGN KEY (treatment_id)
        REFERENCES public.treatments (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.invoice_items
    OWNER to postgres;

    CREATE INDEX "invoice_items index"
    ON public.invoice_items USING btree
    (id ASC NULLS LAST, unit_price ASC NULLS LAST, quantity ASC NULLS LAST, total_price ASC NULLS LAST, invoice_id ASC NULLS LAST, treatment_id ASC NULLS LAST)
    TABLESPACE pg_default;

    CREATE INDEX "invoices index"
    ON public.invoices USING btree
    (id ASC NULLS LAST, total_amount ASC NULLS LAST, generated_at ASC NULLS LAST, payed_at ASC NULLS LAST, medical_history_id ASC NULLS LAST)
    TABLESPACE pg_default;

    CREATE INDEX "medical_histories index"
    ON public.medical_histories USING btree
    (id ASC NULLS LAST, admitted_at ASC NULLS LAST, patient_id ASC NULLS LAST, status ASC NULLS LAST)
    TABLESPACE pg_default;

    CREATE INDEX "patients index"
    ON public.patients USING btree
    (id ASC NULLS LAST, name ASC NULLS LAST, date_of_birth ASC NULLS LAST)
    TABLESPACE pg_default;

    CREATE INDEX "treatments index"
    ON public.treatments USING btree
    (id ASC NULLS LAST, type ASC NULLS LAST, name ASC NULLS LAST)
    TABLESPACE pg_default;

    CREATE TABLE medical_histories_has_treatments (
    medical_history_id int refrences medical_histories(id),
    treatment_id int refrences treatments(id),
    );
    