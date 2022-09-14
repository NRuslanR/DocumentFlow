unit DocumentFlowAdminPrivilegeSetHolder;

interface

uses

  SystemAdministrationPrivilegeSetHolder,
  AbstractDataSetHolder,
  SysUtils;

type

  TDocumentFlowAdminPrivilegeSetFieldDefs = class (TSystemAdministrationPrivilegeSetFieldDefs)

  end;
  
  TDocumentFlowAdminPrivilegeSetHolder = class (TSystemAdministrationPrivilegeSetHolder)

    protected

      function GetDocumentFlowAdminPrivilegeSetFieldDefs: TDocumentFlowAdminPrivilegeSetFieldDefs;

      procedure SetDocumentFlowAdminPrivilegeSetFieldDefs(
        const Value: TDocumentFlowAdminPrivilegeSetFieldDefs
      );
    
    protected

      class function GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass; override;

    public

      property FieldDefs: TDocumentFlowAdminPrivilegeSetFieldDefs
      read GetDocumentFlowAdminPrivilegeSetFieldDefs
      write SetDocumentFlowAdminPrivilegeSetFieldDefs;
      
  end;
  
implementation

{ TDocumentFlowAdminPrivilegeSetHolder }

class function TDocumentFlowAdminPrivilegeSetHolder.GetDataSetFieldDefsClass: TAbstractDataSetFieldDefsClass;
begin

  Result := TDocumentFlowAdminPrivilegeSetFieldDefs;
  
end;

function TDocumentFlowAdminPrivilegeSetHolder.
  GetDocumentFlowAdminPrivilegeSetFieldDefs: TDocumentFlowAdminPrivilegeSetFieldDefs;
begin

  Result := TDocumentFlowAdminPrivilegeSetFieldDefs(inherited FieldDefs);
  
end;

procedure TDocumentFlowAdminPrivilegeSetHolder.SetDocumentFlowAdminPrivilegeSetFieldDefs(
  const Value: TDocumentFlowAdminPrivilegeSetFieldDefs);
begin

  inherited FieldDefs := Value;
  
end;

end.
