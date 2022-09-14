unit unNotDocumentApprovingReasonInputForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DocumentFlowSystemInputMemoFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, StdCtrls, cxButtons;

type
  TNotDocumentApprovingReasonInputForm = class(TDocumentFlowSystemInputMemoForm)
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NotDocumentApprovingReasonInputForm: TNotDocumentApprovingReasonInputForm;

implementation

{$R *.dfm}

uses

  AuxWindowsFunctionsUnit;
  
procedure TNotDocumentApprovingReasonInputForm.OKButtonClick(Sender: TObject);
begin

  if Trim(InputMemo.Text) = '' then begin

    ShowWarningMessage(
      Self.Handle,
      'Пожалуйста, укажите причину ' +
      'отклонения согласования документа',
      'Сообщение'
    );
    
  end

  else inherited;


end;

end.
