unit BasedOnDatabaseEmployeeIncomingDocumentSetReadService;

interface

uses

  BasedOnDatabaseAbstractEmployeeDocumentSetReadService,
  IncomingDocumentSetHolder,
  IncomingDocumentSetHolderFactory,
  DocumentSetHolderFactory,
  EmployeeDocumentSetHolderFactory,
  EmployeeDocumentKindAccessRightsService,
  EmployeeDocumentKindAccessRightsInfo,
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
          EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
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
  EmployeeDocumentKindAccessRightsInfo: TEmployeeDocumentKindAccessRightsInfo
);
begin

  inherited SetDocumentSetOperationAccessRights(
    DocumentSetHolder, EmployeeDocumentKindAccessRightsInfo
  );

  with
    TIncomingDocumentSetHolder(
      TAbstractDocumentSetHolderDecorator(
        DocumentSetHolder
      ).GetNestedDocumentSetHolderByType(TIncomingDocumentSetHolder)
    ),
    EmployeeDocumentKindAccessRightsInfo
  do begin

    RespondingDocumentCreatingAllowed := CanCreateRespondingDocuments;

  end;

end;

end.
