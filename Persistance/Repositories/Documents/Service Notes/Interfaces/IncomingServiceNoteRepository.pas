unit IncomingServiceNoteRepository;

interface

uses

  IncomingServiceNote,
  IncomingDocumentRepository;

type

  IIncomingServiceNoteRepository = interface (IIncomingDocumentRepository)
    
    function LoadAllIncomingServiceNotes: TIncomingServiceNotes;
      
    function FindIncomingServiceNoteById(
      const IncomingServiceNoteId: Variant
    ): TIncomingServiceNote;

    procedure AddIncomingServiceNote(
      IncomingServiceNote: TIncomingServiceNote
    );

    procedure AddIncomingServiceNotes(
      IncomingServiceNotes: TIncomingServiceNotes
    );
        
    procedure UpdateIncomingServiceNote(
      IncomingServiceNote: TIncomingServiceNote
    );

    procedure UpdateIncomingServiceNotes(
      IncomingServiceNotes: TIncomingServiceNotes
    );

    procedure RemoveIncomingServiceNote(
      IncomingServiceNote: TIncomingServiceNote
    );

    procedure RemoveIncomingServiceNotes(
      IncomingServiceNotes: TIncomingServiceNotes
    );

  end;


implementation

end.
