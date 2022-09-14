unit DocumentApprovingRepository;

interface

uses

  DocumentApprovings,
  IGetSelfUnit,
  SysUtils;

type

  IDocumentApprovingRepository = interface (IGetSelf)

    function FindAllApprovingsForDocument(
      const DocumentId: Variant
    ): TDocumentApprovings;

    procedure AddDocumentApprovings(
      DocumentApprovings: TDocumentApprovings
    );

    procedure RemoveAllDocumentApprovings(const DocumentId: Variant);

  end;

implementation

end.
