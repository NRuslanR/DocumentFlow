unit BasedOnRepositoryDocumentWorkCycleFinder;

interface

uses

  DocumentWorkCycleFinder,
  DocumentWorkCycleRepository,
  DocumentWorkCycle;

type

  TBasedOnRepositoryDocumentWorkCycleFinder =
    class (TInterfacedObject, IDocumentWorkCycleFinder)

      private

        FDocumentWorkCycleRepository: IDocumentWorkCycleRepository;

      public

        constructor Create(
          DocumentWorkCycleRepository: IDocumentWorkCycleRepository
        );
        
        function FindWorkCycleForDocumentKind(const DocumentKindId: Variant): TDocumentWorkCycle;

    end;

implementation

{ TBasedOnRepositoryDocumentWorkCycleFinder }

constructor TBasedOnRepositoryDocumentWorkCycleFinder.Create(
  DocumentWorkCycleRepository: IDocumentWorkCycleRepository);
begin

  inherited Create;

  FDocumentWorkCycleRepository := DocumentWorkCycleRepository;

end;

function TBasedOnRepositoryDocumentWorkCycleFinder.FindWorkCycleForDocumentKind(
  const DocumentKindId: Variant): TDocumentWorkCycle;
begin

  Result := FDocumentWorkCycleRepository.FindWorkCycleForDocumentKind(DocumentKindId);

end;

end.
