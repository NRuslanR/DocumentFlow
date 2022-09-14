unit PostgresDocumentRelationsInfoQueryBuilder;

interface

uses

  DocumentRelationsInfoHolder,
  DocumentRelationsTableDef,
  DocumentRelationsInfoQueryBuilder,
  SysUtils;

type

  TPostgresDocumentRelationsInfoQueryBuilder =
    class (TDocumentRelationsInfoQueryBuilder)

      public

        function BuildDocumentRelationsInfoQuery(
          FieldNames: TDocumentRelationsInfoFieldNames;
          DocumentIdParamName: String
        ): String; override;

    end;

implementation

{ TPostgresDocumentRelationsInfoQueryBuilder }

function TPostgresDocumentRelationsInfoQueryBuilder.BuildDocumentRelationsInfoQuery(
  FieldNames: TDocumentRelationsInfoFieldNames;
  DocumentIdParamName: String): String;
begin

  with FieldNames do begin

    Result :=
      'select distinct' + #13#10 +
        'doc_links.id as ' + DocumentRelationIdFieldName + ',' + #13#10 +
        'doc_links.document_id as ' + TargetDocumentIdFieldName + ',' + #13#10 + 
        'coalesce(rel_docs.id, rel_servs.id, rel_po.id) as ' + RelatedDocumentIdFieldName + ',' + #13#10 +
        'coalesce(rel_docs.type_id, rel_servs.type_id, rel_po.type_id) as ' + RelatedDocumentKindIdFieldName + ',' + #13#10 +
        'coalesce(rel_doc_type.single_full_name, rel_serv_type.single_full_name, rel_po_type.single_full_name) as ' + RelatedDocumentKindNameFieldName + ',' + #13#10 +
        'coalesce(rel_docs.document_number, rel_servs.document_number, rel_po.document_number) as ' + RelatedDocumentNumberFieldName + ',' + #13#10 +
        'coalesce(rel_docs.name, rel_servs.name, rel_po.name) as ' + RelatedDocumentNameFieldName + ',' + #13#10 + 
        'coalesce(rel_docs.document_date, rel_servs.document_date, rel_po.document_date) as ' + RelatedDocumentDateFieldName + #13#10 + 
  
      'from ' + FDocumentRelationsTableDef.TableName + ' doc_links' + #13#10 +
      'left join lateral' + #13#10 + 
      '(' + #13#10 + 
        'select' + #13#10 + 
          'doc_links.related_document_id as id,' + #13#10 + 
          'doc_links.related_document_type_id as type_id,' + #13#10 + 
          'rel_servs.document_number,' + #13#10 + 
          'rel_servs.name,' + #13#10 + 
          'rel_servs.document_date' + #13#10 + 
        'from doc.service_notes rel_servs' + #13#10 + 
        'where rel_servs.id = doc_links.related_document_id and rel_servs.type_id = doc_links.related_document_type_id' + #13#10 + 
        'or exists (' + #13#10 + 
          'select 1 from doc.service_note_receivers a' + #13#10 + 
          'where a.document_id = rel_servs.id and a.id = doc_links.related_document_id and a.incoming_document_type_id = doc_links.related_document_type_id' + #13#10 + 
        ')' + #13#10 + 
      ') rel_servs on rel_servs.id = doc_links.related_document_id' + #13#10 + 
      'left join lateral' + #13#10 + 
      '(' + #13#10 + 
        'select' + #13#10 + 
          'doc_links.related_document_id as id,' + #13#10 + 
          'doc_links.related_document_type_id as type_id,' + #13#10 + 
          'rel_docs.document_number,' + #13#10 + 
          'rel_docs.name,' + #13#10 + 
          'rel_docs.document_date' + #13#10 + 
        'from doc.documents rel_docs' + #13#10 + 
        'where rel_docs.id = doc_links.related_document_id and rel_docs.type_id = doc_links.related_document_type_id' + #13#10 + 
        'or exists(' + #13#10 + 
          'select 1 from doc.document_receivers a' + #13#10 + 
          'where a.document_id = rel_docs.id and a.id = doc_links.related_document_id and a.incoming_document_type_id = doc_links.related_document_type_id' + #13#10 + 
        ')' + #13#10 + 
      ') rel_docs on rel_docs.id = doc_links.related_document_id' + #13#10 + 
      'left join lateral ( select doc_links.related_document_id as id,doc_links.related_document_type_id as type_id,rel_po.document_number,rel_po.name,rel_po.document_date' + #13#10 + 
                'from doc.personnel_orders rel_po ' + #13#10 + 
                'where rel_po.id = doc_links.related_document_id and rel_po.type_id = doc_links.related_document_type_id) rel_po on rel_po.id = doc_links.related_document_id ' + #13#10 + 
      'left join doc.document_types rel_doc_type on rel_doc_type.id = rel_docs.type_id' + #13#10 + 
      'left join doc.document_types rel_serv_type on rel_serv_type.id = rel_servs.type_id' + #13#10 + 
      'left join doc.document_types rel_po_type on rel_po_type.id = rel_po.type_id ' + #13#10 + 

      'where doc_links.document_id=:' + DocumentIdParamName;
      
  end;
  
end;

end.
