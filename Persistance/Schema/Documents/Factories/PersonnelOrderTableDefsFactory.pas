unit PersonnelOrderTableDefsFactory;

interface

uses

  DocumentTableDefsFactory,
  PersonnelOrderEmployeeListTableDef,
  PersonnelOrderSubKindEmployeeListTableDef,
  PersonnelOrderEmployeeGroupTableDef,
  PersonnelOrderSubKindTableDef,
  PersonnelOrdersTableDef,
  DocumentTableDef,
  PersonnelOrderEmployeeGroupEmployeeAssociationTableDef,
  PersonnelOrderEmployeeGroupSubKindAssociationTableDef,
  PersonnelOrderSignerListTableDef,
  DocumentChargeSheetTableDef,
  DocumentChargeTableDef,
  TableDef,
  SysUtils;

type

  TPersonnelOrderTableDefsFactory = class (TDocumentTableDefsFactory)

    protected

      function CreateDocumentTableDefInstance: TDocumentTableDef; override;
      
    protected

      procedure FillDocumentTableDef(DocumentTableDef: TTableDef); override;
      procedure FillDocumentApprovingsTableDef(DocumentApprovingsTableDef: TTableDef); override;
      procedure FillDocumentChargeSheetTableDef(DocumentChargeSheetTableDef: TTableDef); override;
      procedure FillDocumentChargeTableDef(DocumentChargeTableDef: TTableDef); override;
      procedure FillDocumentFilesTableDef(DocumentFilesTableDef: TTableDef); override;
      procedure FillDocumentRelationsTableDef(DocumentRelationsTableDef: TTableDef); override;
      procedure FillDocumentSigningTableDef(DocumentSigningTableDef: TTableDef); override;
      procedure FillLookedDocumentsTableDef(DocumentTableDef: TTableDef); override;

    public

      function CreatePersonnelOrderCreatingAccessEmployeeTableDef: TPersonnelOrderEmployeeListTableDef;
      function CreatePersonnelOrderSignerListTableDef: TPersonnelOrderSignerListTableDef;
      function CreatePersonnelOrderApproverListTableDef: TPersonnelOrderSubKindEmployeeListTableDef;
      function CreatePersonnelOrderControlGroupTableDef: TPersonnelOrderEmployeeGroupTableDef;
      function CreatePersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef;
      function CreatePersonnelOrderControlGroupEmployeeAssociationTableDef: TPersonnelOrderEmployeeGroupEmployeeAssociationTableDef;
      function CreatePersonnelOrderControlGroupSubKindAssociationTableDef: TPersonnelOrderEmployeeGroupSubKindAssociationTableDef;

   end;
  
implementation

{ TPersonnelOrderTableDefsFactory }

function TPersonnelOrderTableDefsFactory.CreateDocumentTableDefInstance: TDocumentTableDef;
begin

  Result := TPersonnelOrdersTableDef.Create;
  
end;

function TPersonnelOrderTableDefsFactory.
  CreatePersonnelOrderApproverListTableDef: TPersonnelOrderSubKindEmployeeListTableDef;
begin

  Result := TPersonnelOrderSubKindEmployeeListTableDef.Create;

  Result.TableName := 'doc.personnel_order_sub_kinds__approvers';

  Result.IdColumnName := 'id';
  Result.PersonnelOrderSubKindIdColumnName := 'personnel_order_sub_kind_id';
  Result.EmployeeIdColumnName := 'approver_id';
  
end;

function TPersonnelOrderTableDefsFactory.
  CreatePersonnelOrderControlGroupEmployeeAssociationTableDef: TPersonnelOrderEmployeeGroupEmployeeAssociationTableDef;
begin

  Result := TPersonnelOrderEmployeeGroupEmployeeAssociationTableDef.Create;

  with Result do begin

    TableName := 'doc.personnel_order_control_groups__employees';

    IdColumnName := 'id';
    GroupIdColumnName := 'control_group_id';
    EmployeeIdColumnName := 'employee_id';
    
  end;
  
end;

function TPersonnelOrderTableDefsFactory.
  CreatePersonnelOrderControlGroupSubKindAssociationTableDef: TPersonnelOrderEmployeeGroupSubKindAssociationTableDef;
begin

  Result := TPersonnelOrderEmployeeGroupSubKindAssociationTableDef.Create;

  with Result do begin

    TableName := 'doc.personnel_order_control_groups__sub_kinds';

    IdColumnName := 'id';
    GroupIdColumnName := 'control_group_id';
    SubKindIdColumnName := 'personnel_order_sub_kind_id';
    
  end;

end;

function TPersonnelOrderTableDefsFactory.CreatePersonnelOrderControlGroupTableDef: TPersonnelOrderEmployeeGroupTableDef;
begin

  Result := TPersonnelOrderEmployeeGroupTableDef.Create;

  Result.TableName := 'doc.personnel_order_control_groups';

  Result.IdColumnName := 'id';
  Result.NameColumnName := 'name';
  
end;

function TPersonnelOrderTableDefsFactory.
  CreatePersonnelOrderCreatingAccessEmployeeTableDef: TPersonnelOrderEmployeeListTableDef;
begin

  Result := TPersonnelOrderEmployeeListTableDef.Create;

  with Result do begin

    TableName := 'doc.personnel_order_creating_access_employees';

    IdColumnName := 'employee_id';
    EmployeeIdColumnName := 'employee_id';
    
  end;

end;

function TPersonnelOrderTableDefsFactory.CreatePersonnelOrderSignerListTableDef: TPersonnelOrderSignerListTableDef;
begin

  Result := TPersonnelOrderSignerListTableDef.Create;

  Result.TableName := 'doc.personnel_order_signers';
  Result.IdColumnName := 'signer_id';
  Result.EmployeeIdColumnName := 'signer_id';
  Result.IsDefaultColumnName := 'is_default';
  
end;

function TPersonnelOrderTableDefsFactory.CreatePersonnelOrderSubKindTableDef: TPersonnelOrderSubKindTableDef;
begin

  Result := TPersonnelOrderSubKindTableDef.Create;

  Result.TableName := 'doc.personnel_order_sub_kinds';

  Result.IdColumnName := 'id';
  Result.NameColumnName := 'name';
  
end;

procedure TPersonnelOrderTableDefsFactory.FillDocumentApprovingsTableDef(
  DocumentApprovingsTableDef: TTableDef);
begin

  inherited;

  DocumentApprovingsTableDef.TableName := 'doc.personnel_order_approvings';
  
end;

procedure TPersonnelOrderTableDefsFactory.FillDocumentChargeSheetTableDef(
  DocumentChargeSheetTableDef: TTableDef);
begin

  inherited FillDocumentChargeSheetTableDef(DocumentChargeSheetTableDef);

  DocumentChargeSheetTableDef.TableName := 'doc.personnel_order_charges';

end;

procedure TPersonnelOrderTableDefsFactory.FillDocumentChargeTableDef(
  DocumentChargeTableDef: TTableDef);
begin

  inherited;

  DocumentChargeTableDef.TableName := 'doc.personnel_order_charges';
  
end;

procedure TPersonnelOrderTableDefsFactory.FillDocumentFilesTableDef(
  DocumentFilesTableDef: TTableDef);
begin

  inherited;

  DocumentFilesTableDef.TableName := 'doc.personnel_order_file_metadata';

end;

procedure TPersonnelOrderTableDefsFactory.FillDocumentRelationsTableDef(
  DocumentRelationsTableDef: TTableDef);
begin

  inherited;

  DocumentRelationsTableDef.TableName := 'doc.personnel_order_links';

end;

procedure TPersonnelOrderTableDefsFactory.FillDocumentSigningTableDef(
  DocumentSigningTableDef: TTableDef);
begin

  inherited;

  DocumentSigningTableDef.TableName := 'doc.personnel_order_signings';
  
end;

procedure TPersonnelOrderTableDefsFactory.FillDocumentTableDef(
  DocumentTableDef: TTableDef);
begin

  inherited;

  DocumentTableDef.TableName := 'doc.personnel_orders';

  with TPersonnelOrdersTableDef(DocumentTableDef) do begin

    SubKindIdColumnName := 'sub_type_id';
    
  end;
  
end;

procedure TPersonnelOrderTableDefsFactory.FillLookedDocumentsTableDef(
  DocumentTableDef: TTableDef);
begin

  inherited;

  DocumentTableDef.TableName := 'doc.looked_personnel_orders';
  
end;

end.
