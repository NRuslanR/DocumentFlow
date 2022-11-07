unit BasedOnDatabaseEmployeeIncomingDocumentSetReadService;

interface

uses

  BasedOnDatabaseAbstractEmployeeDocumentSetReadService,
  IncomingDocumentSetHolder,
  IncomingDocumentSetHolderFactory,
  DocumentSetHolderFactory,
  EmployeeDocumentSetHolderFactory,
  EmployeeDocumentKindAccessRightsAppService,
  EmployeeDocumentKindAccessRightsInfoDto,
  AbstractDocumentSetHolderDecorator,
  DocumentSetHolder,
  SysUtils;

type

  TBasedOnDatabaseEmployeeIncomingDocumentSetReadService =
    class abstract (TBasedOnDatabaseAbstractEmployeeDocumentSetReadService)

      protected

        function CreateDocumentSetHolderFactory: TDocumentSetHolderFactory; override;

      protected

        procedure SetDocumentSetOperationAccessRights(
          DocumentSetHolder: TDocumentSetHolder;
          EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
        ); override;

    end;
  
implementation

{ TBasedOnDatabaseEmployeeIncomingDocumentSetReadService }

function TBasedOnDatabaseEmployeeIncomingDocumentSetReadService.
  CreateDocumentSetHolderFactory: TDocumentSetHolderFactory;
begin

  Result :=
    TEmployeeDocumentSetHolderFactory.Create(
      TIncomingDocumentSetHolderFactory.Create(
        TDocumentSetHolderFactory.Create
      )
    );

end;

procedure TBasedOnDatabaseEmployeeIncomingDocumentSetReadService.SetDocumentSetOperationAccessRights(
  DocumentSetHolder: TDocumentSetHolder;
  EmployeeDocumentKindAccessRightsInfoDto: TEmployeeDocumentKindAccessRightsInfoDto
);
begin

  inherited SetDocumentSetOperationAccessRights(
    DocumentSetHolder, EmployeeDocumentKindAccessRightsInfoDto
  );

  with
    TIncomingDocumentSetHolder(
      TAbstractDocumentSetHolderDecorator(
        DocumentSetHolder
      ).GetNestedDocumentSetHolderByType(TIncomingDocumentSetHolder)
    ),
    EmployeeDocumentKindAccessRightsInfoDto
  do begin

    RespondingDocumentCreatingAllowed := CanCreateRespondingDocuments;

  end;

end;

end.
