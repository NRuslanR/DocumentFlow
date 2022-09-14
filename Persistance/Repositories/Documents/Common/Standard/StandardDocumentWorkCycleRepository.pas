unit StandardDocumentWorkCycleRepository;

interface

uses

  DocumentWorkCycleRepository,
  DocumentWorkCycle,
  DocumentKindRepository,
  DocumentWorkCycleStagesRepository,
  DocumentKind,
  SysUtils;

type

  TStandardDocumentWorkCycleRepository =
    class (TInterfacedObject, IDocumentWorkCycleRepository)

      protected

        FDocumentKindRepository: IDocumentKindRepository;
        FDocumentWorkCycleStagesRepository: IDocumentWorkCycleStagesRepository;

      public

        constructor Create(
          DocumentKindRepository: IDocumentKindRepository;
          DocumentWorkCycleStagesRepository: IDocumentWorkCycleStagesRepository
        );

        function FindWorkCycleForDocumentKind(const DocumentKindId: Variant): TDocumentWorkCycle;

    end;
  

implementation

uses

  IDomainObjectBaseUnit;

{ TStandardDocumentWorkCycleRepository }

constructor TStandardDocumentWorkCycleRepository.Create(
  DocumentKindRepository: IDocumentKindRepository;
  DocumentWorkCycleStagesRepository: IDocumentWorkCycleStagesRepository
);
begin

  inherited Create;

  FDocumentKindRepository := DocumentKindRepository;
  FDocumentWorkCycleStagesRepository := DocumentWorkCycleStagesRepository;

end;

function TStandardDocumentWorkCycleRepository.FindWorkCycleForDocumentKind(
  const DocumentKindId: Variant): TDocumentWorkCycle;
var
    DocumentKind: TDocumentKind;
    Free: IDomainObjectBase;
begin

  DocumentKind := FDocumentKindRepository.FindDocumentKindByIdentity(DocumentKindId);

  Free := DocumentKind;

  Result :=
    DocumentKind.DocumentClass.WorkCycleType.Create(
      FDocumentWorkCycleStagesRepository
        .FindWorkCycleStagesForDocumentKind(DocumentKindId)
    );

end;

end.
