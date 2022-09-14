unit ServiceNoteRepository;

interface

uses

  ServiceNote,
  DocumentRepository;
  
type

  IServiceNoteRepository = interface (IDocumentRepository)

    function LoadAllServiceNotes: TServiceNotes;

    function FindServiceNoteById(const ServiceNoteId: Variant): TServiceNote;

    procedure AddServiceNote(ServiceNote: TServiceNote);
    procedure AddServiceNotes(ServiceNotes: TServiceNotes);

    procedure UpdateServiceNote(ServiceNote: TServiceNote);
    procedure UpdateServiceNotes(ServiceNotes: TServiceNotes);

    procedure RemoveServiceNote(ServiceNote: TServiceNote);
    procedure RemoveServiceNotes(ServiceNotes: TServiceNotes);

  end;
  
implementation

end.
