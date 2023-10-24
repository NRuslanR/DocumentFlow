unit IncomingInternalServiceNote;

interface

uses

  IncomingDocument,
  Document,
  DocumentChargeSheet,
  IncomingInternalDocument,
  IncomingServiceNote,
  SysUtils,
  Classes;

type

  TIncomingInternalServiceNote = class (TIncomingInternalDocument)

    protected

      function GetOriginalIncomingServiceNote: TIncomingServiceNote;
      procedure SetOriginalIncomingServiceNote(const Value: TIncomingServiceNote);

    protected

      procedure SetOriginalDocument(const Value: TDocument); override;

    public

      class function ListType: TDocumentsClass; override;
      class function OutcomingDocumentType: TDocumentClass; override;

      property OriginalIncomingServiceNote: TIncomingServiceNote
      read GetOriginalIncomingServiceNote write SetOriginalIncomingServiceNote;
    
  end;

  TIncomingInternalServiceNotes = class;

  TIncomingInternalServiceNotesEnumerator =
    class (TIncomingInternalDocumentsEnumerator)

      protected

        function GetCurrentIncomingInternalServiceNote: TIncomingInternalServiceNote;

      public

        constructor Create(IncomingInternalServiceNotes: TIncomingInternalServiceNotes);

        property Current: TIncomingInternalServiceNote
        read GetCurrentIncomingInternalServiceNote;

    end;
  
  TIncomingInternalServiceNotes = class (TIncomingInternalDocuments)

    public

      function GetEnumerator: TIncomingInternalServiceNotesEnumerator;
  
  end;
  
implementation

uses

  InternalServiceNote;

{ TIncomingInternalServiceNote }

procedure TIncomingInternalServiceNote.SetOriginalDocument(
  const Value: TDocument);
begin

  if not Value.InheritsFrom(TIncomingServiceNote) then begin

    raise TIncomingDocumentException.CreateFmt(
      'Программная ошибка. Документ типа "%s" ' +
      'не является входящей служебной запиской ' +
      'для ссылки из входящей внутренней ' +
      'служебной записки',
      [
        Value.ClassName
      ]
    );
    
  end;

  inherited;

end;

function TIncomingInternalServiceNote.
  GetOriginalIncomingServiceNote: TIncomingServiceNote;
begin

  Result := TIncomingServiceNote(GetOriginalIncomingDocument);
  
end;

class function TIncomingInternalServiceNote.ListType: TDocumentsClass;
begin

  Result := TIncomingInternalServiceNotes;

end;

class function TIncomingInternalServiceNote.OutcomingDocumentType: TDocumentClass;
begin

  Result := TInternalServiceNote;

end;

procedure TIncomingInternalServiceNote.SetOriginalIncomingServiceNote(
  const Value: TIncomingServiceNote);
begin

  SetOriginalIncomingDocument(Value);
  
end;

{ TIncomingInternalServiceNotesEnumerator }

constructor TIncomingInternalServiceNotesEnumerator.Create(
  IncomingInternalServiceNotes: TIncomingInternalServiceNotes);
begin

  inherited Create(IncomingInternalServiceNotes);
  
end;

function TIncomingInternalServiceNotesEnumerator.
  GetCurrentIncomingInternalServiceNote: TIncomingInternalServiceNote;
begin

  Result := TIncomingInternalServiceNote(GetCurrentIncomingInternalDocument);
  
end;

{ TIncomingInternalServiceNotes }

function TIncomingInternalServiceNotes.GetEnumerator:
  TIncomingInternalServiceNotesEnumerator;
begin

  Result := TIncomingInternalServiceNotesEnumerator.Create(Self);

end;

end.
