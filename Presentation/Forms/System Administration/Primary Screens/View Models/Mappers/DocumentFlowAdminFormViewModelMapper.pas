unit DocumentFlowAdminFormViewModelMapper;

interface

uses

  SystemAdministrationFormViewModelMapper,
  SystemAdministrationFormViewModel,
  SystemAdministrationPrivilegeSetHolder,
  SystemAdministrationPrivilegeViewModel,
  DocumentFlowAdminPrivileges,
  DocumentFlowAdminPrivilegeViewModel,
  DocumentFlowAdministrationFormViewModel,
  SysUtils;

type

  TDocumentFlowAdminFormViewModelMapper = class (TSystemAdministrationFormViewModelMapper)

    protected

        function GetSystemAdministrationFormViewModelClass: TSystemAdministrationFormViewModelClass; override;

        function GetSystemAdministrationPrivilegeSetHolderClass: TSystemAdministrationPrivilegeSetHolderClass; override;

        function GetSystemAdministrationPrivilegeSetFieldDefsClass: TSystemAdministrationPrivilegeSetFieldDefsClass; override;

        function GetSystemAdministrationPrivilegeViewModelClass:
          TSystemAdministrationPrivilegeViewModelClass; override;
          
      public

        function MapDocumentFlowAdminFormViewModelFrom(
          DocumentFlowAdminPrivileges: TDocumentFlowAdminPrivileges
        ): TDocumentFlowAdministrationFormViewModel;

  end;
  
implementation

uses

  DocumentFlowAdminPrivilegeSetHolder;
  
{ TDocumentFlowAdminFormViewModelMapper }

function TDocumentFlowAdminFormViewModelMapper.
  GetSystemAdministrationFormViewModelClass: TSystemAdministrationFormViewModelClass;
begin

  Result := TDocumentFlowAdministrationFormViewModel;
  
end;

function TDocumentFlowAdminFormViewModelMapper.
  GetSystemAdministrationPrivilegeSetFieldDefsClass: TSystemAdministrationPrivilegeSetFieldDefsClass;
begin

  Result := TDocumentFlowAdminPrivilegeSetFieldDefs;
  
end;

function TDocumentFlowAdminFormViewModelMapper.
  GetSystemAdministrationPrivilegeSetHolderClass: TSystemAdministrationPrivilegeSetHolderClass;
begin

  Result := TDocumentFlowAdminPrivilegeSetHolder;
  
end;

function TDocumentFlowAdminFormViewModelMapper.
  GetSystemAdministrationPrivilegeViewModelClass: TSystemAdministrationPrivilegeViewModelClass;
begin

  Result := TDocumentFlowAdminPrivilegeViewModel;
  
end;

function TDocumentFlowAdminFormViewModelMapper.
  MapDocumentFlowAdminFormViewModelFrom(
    DocumentFlowAdminPrivileges: TDocumentFlowAdminPrivileges
  ): TDocumentFlowAdministrationFormViewModel;
begin

  Result :=
    TDocumentFlowAdministrationFormViewModel(
      MapSystemAdministrationFormViewModelFrom(DocumentFlowAdminPrivileges)
    );
    
end;

end.
