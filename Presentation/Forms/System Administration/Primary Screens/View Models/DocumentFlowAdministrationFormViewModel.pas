unit DocumentFlowAdministrationFormViewModel;

interface

uses

  SystemAdministrationFormViewModel,
  DocumentFlowAdminPrivilegeSetHolder,
  DocumentFlowAdminPrivilegeViewModel,
  SystemAdministrationPrivilegeSetHolder,
  SectionRecordViewModel,
  SysUtils;

type

  TDocumentFlowAdministrationFormViewModel = class (TSystemAdministrationFormViewModel)

    private

      function GetDocumentFlowAdminPrivilegeSetHolder: TDocumentFlowAdminPrivilegeSetHolder;

      procedure SetDocumentFlowAdminPrivilegeSetHolder(
        const Value: TDocumentFlowAdminPrivilegeSetHolder
      );
      
    protected

      function GetSectionRecordViewModelClass: TSectionRecordViewModelClass; override;

    public

      property DocumentFlowAdminPrivilegeSetHolder: TDocumentFlowAdminPrivilegeSetHolder
      read GetDocumentFlowAdminPrivilegeSetHolder
      write SetDocumentFlowAdminPrivilegeSetHolder;

  
  end;

implementation

{ TDocumentFlowAdministrationFormViewModel }

function TDocumentFlowAdministrationFormViewModel.
  GetDocumentFlowAdminPrivilegeSetHolder: TDocumentFlowAdminPrivilegeSetHolder;
begin

  Result :=
    TDocumentFlowAdminPrivilegeSetHolder(SystemAdministrationPrivilegeSetHolder);
    
end;

function TDocumentFlowAdministrationFormViewModel.
  GetSectionRecordViewModelClass: TSectionRecordViewModelClass;
begin

  Result := TDocumentFlowAdminPrivilegeViewModel;
  
end;

procedure TDocumentFlowAdministrationFormViewModel.
  SetDocumentFlowAdminPrivilegeSetHolder(
    const Value: TDocumentFlowAdminPrivilegeSetHolder
  );
begin

  inherited SystemAdministrationPrivilegeSetHolder := Value;
  
end;

end.
