unit StandardDocumentsAdminPrivilegeServicesFactory;

interface

uses

  AbstractDocumentFlowAdminPrivilegeServicesFactory,
  DocumentFlowAdminPrivilegeServices,
  DocumentFlowAdminPrivileges,
  DocumentsAdminPrivilegeServices,
  DocumentKindResolver,
  DocumentKinds,
  SysUtils;

type

  TStandardDocumentsAdminPrivilegeServicesFactory =
    class (TAbstractDocumentFlowAdminPrivilegeServicesFactory)

      private

        FDocumenKindResolver: IDocumentKindResolver;
        
      public

        constructor Create(
          const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
          DocumentKindResolver: IDocumentKindResolver
        );
        
        function CreateDocumentFlowAdminPrivilegeServices:
          TDocumentFlowAdminPrivilegeServices; override;
          
    end;

implementation

uses

  ApplicationServiceRegistries;
  
{ TStandardDocumentsAdminPrivilegeServicesFactory }

constructor TStandardDocumentsAdminPrivilegeServicesFactory.Create(
  const DocumentFlowAdminPrivilege: TDocumentFlowAdminPrivilege;
  DocumentKindResolver: IDocumentKindResolver
);
begin

  inherited Create(DocumentFlowAdminPrivilege);

  FDocumenKindResolver := DocumentKindResolver;
  
end;

function TStandardDocumentsAdminPrivilegeServicesFactory.
  CreateDocumentFlowAdminPrivilegeServices: TDocumentFlowAdminPrivilegeServices;
var
    ServiceDocumentKind: TDocumentKindClass;
begin

  ServiceDocumentKind := FDocumenKindResolver.ResovleDocumentKindById(FWorkingPrivilegeId);

  Result :=
    TDocumentsAdminPrivilegeServices.Create(
      FPrivilegeId,
      FWorkingPrivilegeId,

      TApplicationServiceRegistries
        .Current
          .GetSystemServiceRegistry
            .GetAdminDocumentSetReadService(ServiceDocumentKind)

    );

end;

end.
