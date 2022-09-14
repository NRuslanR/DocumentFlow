unit DocumentWorkCycleStagesRepository;

interface

uses

  DocumentWorkCycle;

type

  IDocumentWorkCycleStagesRepository = interface

    function FindWorkCycleStagesForDocumentKind(
      const DocumentKindId: Variant
    ): TDocumentWorkCycleStages;

    function FindDocumentWorkCycleStageByDocumentKindAndStageNumber(
      const DocumentKindId: Variant;
      const StageNumber: Integer
    ): TDocumentWorkCycleStage;

  end;

implementation

end.
