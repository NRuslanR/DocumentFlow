unit DocumentApprovingsPicker;

interface

uses

  DomainException,
  DocumentApprovingCycleResult,
  DocumentApprovings,
  SysUtils;

type

  TDocumentApprovingsPickerException = class (TDomainException)

  end;
  
  IDocumentApprovingsPicker = interface

    function PickDocumentApprovingsFrom(
      const DocumentApprovings: TDocumentApprovings
    ): TDocumentApprovings; overload;

    function PickDocumentApprovingsFrom(
      const DocumentApprovingCycleResults: TDocumentApprovingCycleResults
    ): TDocumentApprovings; overload;

    function PickDocumentApprovingsFrom(
      const DocumentApprovings: TDocumentApprovings;
      const DocumentApprovingCycleResults: TDocumentApprovingCycleResults
    ): TDocumentApprovings; overload;

  end;
  
implementation

end.
