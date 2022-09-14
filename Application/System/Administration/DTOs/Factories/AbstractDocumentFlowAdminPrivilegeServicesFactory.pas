{ Базовый класс для фабрик dto с
  сервисами для админских привилегий
}
unit AbstractDocumentFlowAdminPrivilegeServicesFactory;

interface

uses

  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivileges,
  SysUtils;

type

  TAbstractDocumentFlowAdminPrivilegeServicesFactory =
    class abstract (TInterfacedObject, IDocumentFlowAdminPrivilegeServicesFactory)

      protected

        FPrivilegeId: Variant;
        FWorkingPrivilegeId: Variant;
        
      public

        constructor Create(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
        );
        
        function CreateDocumentFlowAdminPrivilegeServices:
          TDocumentFlowAdminPrivilegeServices; virtual; abstract;
          
    end;
  
implementation

{ TAbstractDocumentFlowAdminPrivilegeServicesFactory }

constructor TAbstractDocumentFlowAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege
);
begin

  inherited Create;

  FPrivilegeId := DocumentFlowAdminPrivilege.Identity;
  FWorkingPrivilegeId := DocumentFlowAdminPrivilege.WorkingPrivilegeId;

end;

end.
