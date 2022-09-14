unit PostgresDocumentRepositoriesFactoryRegistry;

interface

uses

  AbstractDocumentRepositoriesFactoryRegistry,
  DocumentRepositoriesFactory,
  SysUtils;

type

  TPostgresDocumentRepositoriesFactoryRegistry =
    class (TAbstractDocumentRepositoriesFactoryRegistry)

      protected

        function CreateServiceNoteRepositoriesFactory: IDocumentRepositoriesFactory; override;
        function CreatePersonnelOrderRepositoriesFactory: IDocumentRepositoriesFactory; override;
        
    end;
  
implementation

uses

  ServiceNote,
  DocumentTableDefsFactoryRegistry,
  PostgresDocumentRepositoriesFactory,

  PersonnelOrder,
  PostgresPersonnelOrderRepositoriesFactory,
  PersonnelOrderTableDefsFactory;

{ TPostgresDocumentRepositoriesFactoryRegistry }

function TPostgresDocumentRepositoriesFactoryRegistry.
  CreateServiceNoteRepositoriesFactory: IDocumentRepositoriesFactory;
begin

  Result :=
    TPostgresDocumentRepositoriesFactory.Create(
      TDocumentTableDefsFactoryRegistry.Instance.GetDocumentTableDefsFactory(
        TServiceNote
      ),
      TServiceNote
    );

end;

function TPostgresDocumentRepositoriesFactoryRegistry.
  CreatePersonnelOrderRepositoriesFactory: IDocumentRepositoriesFactory;
begin

  Result :=
    TPostgresPersonnelOrderRepositoriesFactory.Create(
      TPersonnelOrderTableDefsFactory(
        TDocumentTableDefsFactoryRegistry.Instance.GetDocumentTableDefsFactory(
          TPersonnelOrder
        )
      )
    );

end;

end.
