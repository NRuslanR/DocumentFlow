unit DocumentApprovingSheetPresenter;

interface

uses

  DocumentApprovingSheetViewModel,
  SysUtils;

type

  IDocumentApprovingSheetPresenter = interface

    procedure PresentDocumentApprovingSheet(
      DocumentApprovingSheetViewModel: TDocumentApprovingSheetViewModel
    );

  end;

implementation

end.
