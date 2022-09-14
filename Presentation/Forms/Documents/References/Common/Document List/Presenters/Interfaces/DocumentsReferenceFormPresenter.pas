unit DocumentsReferenceFormPresenter;

interface

uses

  Controls,
  OperationalDocumentKindInfo,
  SysUtils;

type

  IDocumentsReferenceFormPresenter = interface

    procedure ShowDocumentsReferenceForm(
      DocumentFlowPrimaryScreen: TWinControl;
      const DocumentKindInfo: IOperationalDocumentKindInfo
    );
    
  end;
  
implementation

end.
