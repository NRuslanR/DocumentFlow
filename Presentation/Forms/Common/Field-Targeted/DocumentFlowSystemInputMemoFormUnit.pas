unit DocumentFlowSystemInputMemoFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, InputMemoFormUnit, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters,
  Menus, StdCtrls, cxButtons, dxSkinsCore, dxSkinsDefaultPainters;

const

  DEFAULT_BACKGROUND_BUTTON_COLOR = $00ebb99d;

type
  TDocumentFlowSystemInputMemoForm = class(TInputMemoForm)
  private

  protected

    procedure Initialize; override;
    
  public

    constructor Create(AOwner: TComponent); override;
    
  end;

var
  DocumentFlowSystemInputMemoForm: TDocumentFlowSystemInputMemoForm;

implementation

{$R *.dfm}

uses

  CommonControlStyles;
  
{ TDocumentInfoInputMemoForm }

constructor TDocumentFlowSystemInputMemoForm.Create(AOwner: TComponent);
begin

  inherited;

  Initialize;

end;

procedure TDocumentFlowSystemInputMemoForm.Initialize;
begin
   
  OKButton.Colors.Default := DEFAULT_BACKGROUND_BUTTON_COLOR;
  CancelButton.Colors.Default := DEFAULT_BACKGROUND_BUTTON_COLOR;
  
end;

end.
