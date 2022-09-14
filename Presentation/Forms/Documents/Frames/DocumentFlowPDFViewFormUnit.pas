unit DocumentFlowPDFViewFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PDFViewFormUnit, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, Menus, ImgList, ActnList, ExtCtrls, ComCtrls,
  StdCtrls, cxButtons, cxDropDownEdit, cxTextEdit, cxMaskEdit;

type
  TDocumentFlowPDFViewForm = class(TPDFViewForm)
    procedure actNextDocumentExecute(Sender: TObject);
    procedure actPrevDocumentExecute(Sender: TObject);
    procedure actShowFirstDocumentPageExecute(Sender: TObject);
    procedure actShowLastDocumentPageExecute(Sender: TObject);
  private
    { Private declarations }

  protected

    procedure SetInitialScrollBarsPositions;
    
  public
    { Public declarations }
  end;

var
  DocumentFlowPDFViewForm: TDocumentFlowPDFViewForm;

implementation

{$R *.dfm}

procedure TDocumentFlowPDFViewForm.actNextDocumentExecute(Sender: TObject);
begin

  inherited;

  SetInitialScrollBarsPositions;

end;

procedure TDocumentFlowPDFViewForm.actPrevDocumentExecute(Sender: TObject);
begin

  inherited;

  SetInitialScrollBarsPositions;

end;

procedure TDocumentFlowPDFViewForm.actShowFirstDocumentPageExecute(
  Sender: TObject);
begin

  inherited;

  SetInitialScrollBarsPositions;
  
end;

procedure TDocumentFlowPDFViewForm.actShowLastDocumentPageExecute(
  Sender: TObject);
begin

  inherited;

  SetInitialScrollBarsPositions;

end;

procedure TDocumentFlowPDFViewForm.SetInitialScrollBarsPositions;
begin

  SetHorizontalScrollBarPosition(0);
  SetVerticalScrollBarPosition(0);
  
end;

end.
