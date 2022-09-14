unit AbstractDocumentApprovingsPicker;

interface

uses

  DocumentApprovingsPicker,
  DocumentApprovings,
  DocumentApprovingCycleResult,
  SysUtils;

type

  TAbstractDocumentApprovingsPicker =
    class (TInterfacedObject, IDocumentApprovingsPicker)

      protected

        function InternalPickDocumentApprovingsFrom(
          const DocumentApprovings: TDocumentApprovings = nil;
          const DocumentApprovingCycleResults: TDocumentApprovingCycleResults = nil
        ): TDocumentApprovings; virtual; abstract;
        
      public

        function PickDocumentApprovingsFrom(
          const DocumentApprovings: TDocumentApprovings
        ): TDocumentApprovings; overload; virtual;

        function PickDocumentApprovingsFrom(
          const DocumentApprovingCycleResults: TDocumentApprovingCycleResults
        ): TDocumentApprovings; overload; virtual;

        function PickDocumentApprovingsFrom(
          const DocumentApprovings: TDocumentApprovings;
          const DocumentApprovingCycleResults: TDocumentApprovingCycleResults
        ): TDocumentApprovings; overload; virtual;

    end;

implementation

{ TAbstractDocumentApprovingsPicker }

function TAbstractDocumentApprovingsPicker.PickDocumentApprovingsFrom(
  const DocumentApprovings: TDocumentApprovings): TDocumentApprovings;
begin

  PickDocumentApprovingsFrom(DocumentApprovings, nil);

end;

function TAbstractDocumentApprovingsPicker.PickDocumentApprovingsFrom(
  const DocumentApprovingCycleResults: TDocumentApprovingCycleResults): TDocumentApprovings;
begin

  PickDocumentApprovingsFrom(nil, DocumentApprovingCycleResults);

end;

function TAbstractDocumentApprovingsPicker.PickDocumentApprovingsFrom(
  const DocumentApprovings: TDocumentApprovings;
  const DocumentApprovingCycleResults: TDocumentApprovingCycleResults
): TDocumentApprovings;
begin

  if
    not Assigned(DocumentApprovings) and
    not Assigned(DocumentApprovingCycleResults)
  then begin

    Result := TDocumentApprovings.Create;

    Exit;
    
  end

  else begin

    Result :=
      InternalPickDocumentApprovingsFrom(
        DocumentApprovings, DocumentApprovingCycleResults
      );

  end;

end;

end.
