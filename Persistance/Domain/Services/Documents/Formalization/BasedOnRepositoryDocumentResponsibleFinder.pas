unit BasedOnRepositoryDocumentResponsibleFinder;

interface

uses

  DocumentResponsibleFinder,
  IDocumentResponsibleRepositoryUnit,
  Employee,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentResponsibleFinder =
    class (TInterfacedObject, IDocumentResponsibleFinder)

      private

        FDocumentResponsibleRepository: IDocumentResponsibleRepository;

      public

        constructor Create(
          DocumentResponsibleRepository: IDocumentResponsibleRepository
        );

        function FindDocumentResponsibleById(
          const DocumentResponsibleId: Variant
        ): TEmployee;

    end;

implementation

{ TBasedOnRepositoryDocumentResponsibleFinder }

constructor TBasedOnRepositoryDocumentResponsibleFinder.Create(
  DocumentResponsibleRepository: IDocumentResponsibleRepository);
begin

  inherited Create;

  FDocumentResponsibleRepository := DocumentResponsibleRepository;
  
end;

function TBasedOnRepositoryDocumentResponsibleFinder.
  FindDocumentResponsibleById(
    const DocumentResponsibleId: Variant
  ): TEmployee;
begin

  Result :=
    FDocumentResponsibleRepository.FindDocumentResponsibleById(
      DocumentResponsibleId
    );
    
end;

end.
