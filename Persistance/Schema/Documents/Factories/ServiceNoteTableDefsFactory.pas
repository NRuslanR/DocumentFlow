unit ServiceNoteTableDefsFactory;

interface

uses

  TableDef,
  DocumentTableDefsFactory,
  DocumentTableDef,
  DocumentApprovingsTableDef,
  DocumentApprovingResultsTableDef,
  DocumentChargeSheetTableDef,
  DocumentChargeTableDef,
  DocumentFilesTableDef,
  DocumentRelationsTableDef,
  DocumentSigningTableDef,
  DocumentTypesTableDef,
  DocumentTypeStageTableDef,
  IncomingDocumentTableDef,
  SysUtils;

type

  TServiceNoteTableDefsFactory = class (TDocumentTableDefsFactory)

    protected

      procedure FillDocumentTableDef(DocumentTableDef: TTableDef); override;
      procedure FillDocumentApprovingsTableDef(DocumentApprovingsTableDef: TTableDef); override;
      procedure FillDocumentChargeSheetTableDef(DocumentChargeSheetTableDef: TTableDef); override;
      procedure FillDocumentChargeTableDef(DocumentChargeTableDef: TTableDef); override;
      procedure FillDocumentFilesTableDef(DocumentFilesTableDef: TTableDef); override;
      procedure FillDocumentRelationsTableDef(DocumentRelationsTableDef: TTableDef); override;
      procedure FillDocumentSigningTableDef(DocumentSigningTableDef: TTableDef); override;
      procedure FillIncomingDocumentTableDef(IncomingDocumentTableDef: TTableDef); override;
      procedure FillLookedDocumentsTableDef(DocumentTableDef: TTableDef); override;
      
  end;
  

implementation

{ TServiceNoteTableDefsFactory }


procedure TServiceNoteTableDefsFactory.FillDocumentApprovingsTableDef(
  DocumentApprovingsTableDef: TTableDef);
begin

  inherited;

  DocumentApprovingsTableDef.TableName := 'doc.service_note_approvings';

end;

procedure TServiceNoteTableDefsFactory.FillDocumentChargeSheetTableDef(
  DocumentChargeSheetTableDef: TTableDef);
begin

  inherited;

  DocumentChargeSheetTableDef.TableName := 'doc.service_note_receivers';
  
end;

procedure TServiceNoteTableDefsFactory.FillDocumentChargeTableDef(
  DocumentChargeTableDef: TTableDef);
begin

  inherited;

  DocumentChargeTableDef.TableName := 'doc.service_note_receivers';
  
end;

procedure TServiceNoteTableDefsFactory.FillDocumentFilesTableDef(
  DocumentFilesTableDef: TTableDef);
begin

  inherited;

  DocumentFilesTableDef.TableName := 'doc.service_note_file_metadata';
  
end;

procedure TServiceNoteTableDefsFactory.FillDocumentRelationsTableDef(
  DocumentRelationsTableDef: TTableDef);
begin

  inherited;

  DocumentRelationsTableDef.TableName := 'doc.service_note_links';
  
end;

procedure TServiceNoteTableDefsFactory.FillDocumentSigningTableDef(
  DocumentSigningTableDef: TTableDef);
begin

  inherited;

  DocumentSigningTableDef.TableName := 'doc.service_note_signings';
  
end;

procedure TServiceNoteTableDefsFactory.FillDocumentTableDef(
  DocumentTableDef: TTableDef);
begin

  inherited;

  DocumentTableDef.TableName := 'doc.service_notes';

  with TDocumentTableDef(DocumentTableDef) do begin

    IsSelfRegisteredColumnName := DOCUMENT_TABLE_IS_SELF_REGISTERED_FIELD;

  end;
  
end;

procedure TServiceNoteTableDefsFactory.FillIncomingDocumentTableDef(
  IncomingDocumentTableDef: TTableDef);
begin

  inherited;

  IncomingDocumentTableDef.TableName := 'doc.service_note_receivers';
  
end;

procedure TServiceNoteTableDefsFactory.FillLookedDocumentsTableDef(
  DocumentTableDef: TTableDef);
begin

  inherited;

  DocumentTableDef.TableName := 'doc.looked_service_notes';
  
end;

end.
