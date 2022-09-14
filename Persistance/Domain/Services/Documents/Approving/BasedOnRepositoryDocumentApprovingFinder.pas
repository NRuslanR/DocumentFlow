unit BasedOnRepositoryDocumentApprovingFinder;

interface

uses

  DocumentApprovingFinder,
  DocumentApprovings,
  DocumentApprovingRepository,
  SysUtils,
  Classes;

type

  TBasedOnRepositoryDocumentApprovingFinder =
    class (TInterfacedObject, IDocumentApprovingFinder)

      protected

        FDocumentApprovingRepository: IDocumentApprovingRepository;

      public

        constructor Create(DocumentApprovingRepository: IDocumentApprovingRepository);
        
        function FindAllApprovingsForDocument(const DocumentId: Variant): TDocumentApprovings;

    end;
  
implementation

{ TBasedOnRepositoryDocumentApprovingFinder }

constructor TBasedOnRepositoryDocumentApprovingFinder.Create(
  DocumentApprovingRepository: IDocumentApprovingRepository);
begin

  inherited Create;

  FDocumentApprovingRepository := DocumentApprovingRepository;
  
end;

function TBasedOnRepositoryDocumentApprovingFinder.
  FindAllApprovingsForDocument(const DocumentId: Variant): TDocumentApprovings;
begin

  Result := FDocumentApprovingRepository.FindAllApprovingsForDocument(DocumentId);

end;

end.
