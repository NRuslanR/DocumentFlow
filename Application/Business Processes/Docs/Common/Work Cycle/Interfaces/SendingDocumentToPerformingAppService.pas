unit SendingDocumentToPerformingAppService;

interface

uses

  ApplicationService;

type

  ISendingDocumentToPerformingAppService = interface (IApplicationService)

    procedure SendDocumentToPerforming(
      const DocumentId: Variant;
      const SendingEmployeeId: Variant
    ); overload;

  end;
  
implementation

uses

	Classes;

end.
