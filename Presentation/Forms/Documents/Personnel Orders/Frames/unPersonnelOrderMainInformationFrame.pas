unit unPersonnelOrderMainInformationFrame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtendedDocumentMainInformationFrameUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, StdCtrls,
  cxButtons, ComCtrls, ValidateRichEdit, RegExprValidateRichEdit,
  ValidateMemoUnit, RegExprValidateMemoUnit, ValidateEditUnit,
  RegExprValidateEditUnit, ExtCtrls, DocumentMainInformationFormViewModelUnit,
  PersonnelOrderSubKindViewModel, PersonnelOrderMainInformationFormViewModel,
  LayoutManager, EmployeeSetHolder;

type

  TOnPersonnelOrderSubKindChangedEventHandler =
    procedure (
      Sender: TObject;
      NewSubKindViewModel: TPersonnelOrderSubKindViewModel
    ) of object;
    
  TPersonnelOrderMainInformationFrame = class(TExtendedDocumentMainInformationFrame)
    PersonnelOrderSubKindLabel: TLabel;
    PersonnelOrderSubKindEdit: TRegExprValidateEdit;
    PersonnelOrderSubKindChooseButton: TcxButton;
    procedure PersonnelOrderSubKindChooseButtonClick(Sender: TObject);

  private

    FOnPersonnelOrderSubKindChangedEventHandler: TOnPersonnelOrderSubKindChangedEventHandler;
    
    function UpdateBy(
      PersonnelOrderSubKind: TPersonnelOrderSubKindViewModel
    ): Boolean;

    function GetPersonnelOrderMainInformationFormViewModel: TPersonnelOrderMainInformationFormViewModel;
    
    procedure SetPersonnelOrderMainInformationFormViewModel(
      const Value: TPersonnelOrderMainInformationFormViewModel
    );

    function InitialViewModel: TPersonnelOrderMainInformationFormViewModel;

  private

    procedure RaiseOnPersonnelOrderSubKindChangedEventHandler(
      NewSubKindViewModel: TPersonnelOrderSubKindViewModel
    );

  protected

    function GetDocumentSignerSetHolder: TEmployeeSetHolder; override;

  protected

    function IsDataChanged: Boolean; override;

    procedure SetViewModel(ViewModel: TDocumentMainInformationFormViewModel); override;

    function ValidateInput: Boolean; override;

    function CreateLayoutManager: TLayoutManager; override;

    procedure OnLayoutBuilded; override;

  public

    property ViewModel: TPersonnelOrderMainInformationFormViewModel
    read GetPersonnelOrderMainInformationFormViewModel
    write SetPersonnelOrderMainInformationFormViewModel;

  public

    property OnPersonnelOrderSubKindChangedEventHandler: TOnPersonnelOrderSubKindChangedEventHandler
    read FOnPersonnelOrderSubKindChangedEventHandler
    write FOnPersonnelOrderSubKindChangedEventHandler;

  end;

implementation

uses

  AuxDebugFunctionsUnit,
  ApplicationServiceRegistries,
  PersonnelOrderSignerSetReadService,
  unPersonnelOrderSubKindsReferenceForm,
  BoxLayoutManager,
  unDocumentCardFrame,
  AuxWindowsFunctionsUnit,
  HorizontalBoxLayoutManager, PresentationServiceRegistry,
  PersonnelOrderPresentationServiceRegistry;
  
{$R *.dfm}

function TPersonnelOrderMainInformationFrame.IsDataChanged: Boolean;
begin

  if Assigned(FInitialViewModel) then begin

    Result :=
      inherited IsDataChanged
      or (
        InitialViewModel.SubKindId <> ViewModel.SubKindId
      );
      
  end

  else begin

    Result :=
      inherited IsDataChanged
      or (
        Trim(PersonnelOrderSubKindEdit.Text) <> ''
      );
      
  end;

end;

procedure TPersonnelOrderMainInformationFrame.OnLayoutBuilded;
begin

  inherited OnLayoutBuilded;

end;

procedure TPersonnelOrderMainInformationFrame.PersonnelOrderSubKindChooseButtonClick(
  Sender: TObject
);
var
    PersonnelOrderSubKindsReferenceForm: TPersonnelOrderSubKindsReferenceForm;
    SelectedPersonnelOrderSubKinds: TPersonnelOrderSubKindViewModels;
begin

  inherited;

  SelectedPersonnelOrderSubKinds := nil;
  
  PersonnelOrderSubKindsReferenceForm :=
    TPersonnelOrderSubKindsReferenceForm.Create(nil);

  try

    PersonnelOrderSubKindsReferenceForm.ChooseRecordActionVisible := True;
    PersonnelOrderSubKindsReferenceForm.EnableMultiSelectionMode := False;
    
    if PersonnelOrderSubKindsReferenceForm.ShowModal <> mrOk then Exit;

    SelectedPersonnelOrderSubKinds :=
      PersonnelOrderSubKindsReferenceForm.SelectedPersonnelOrderSubKinds;

    if UpdateBy(SelectedPersonnelOrderSubKinds[0]) then
      RaiseOnPersonnelOrderSubKindChangedEventHandler(SelectedPersonnelOrderSubKinds[0]);
    
  finally

    FreeAndNil(SelectedPersonnelOrderSubKinds);
    FreeAndNil(PersonnelOrderSubKindsReferenceForm);

  end;

end;

procedure TPersonnelOrderMainInformationFrame.RaiseOnPersonnelOrderSubKindChangedEventHandler(
  NewSubKindViewModel: TPersonnelOrderSubKindViewModel
);
begin

  if Assigned(FOnPersonnelOrderSubKindChangedEventHandler) then begin

    FOnPersonnelOrderSubKindChangedEventHandler(
      Self, NewSubKindViewModel
    );
    
  end;

end;

function TPersonnelOrderMainInformationFrame.UpdateBy(
  PersonnelOrderSubKind: TPersonnelOrderSubKindViewModel
): Boolean;
begin

  Result := ViewModel.SubKindId <> PersonnelOrderSubKind.Id;
  
  PersonnelOrderSubKindEdit.Text := PersonnelOrderSubKind.Name;

  ViewModel.SubKindId := PersonnelOrderSubKind.Id;
  ViewModel.SubKindName := PersonnelOrderSubKind.Name;

end;

function TPersonnelOrderMainInformationFrame.ValidateInput: Boolean;
var
    IsPersonnelOrderSubKindValid: Boolean;
begin

  IsPersonnelOrderSubKindValid := PersonnelOrderSubKindEdit.IsValid;
  
  Result :=
    inherited ValidateInput
    and IsPersonnelOrderSubKindValid;
    
end;

function TPersonnelOrderMainInformationFrame.InitialViewModel: TPersonnelOrderMainInformationFormViewModel;
begin

  Result := FInitialViewModel as TPersonnelOrderMainInformationFormViewModel;
  
end;

function TPersonnelOrderMainInformationFrame.CreateLayoutManager: TLayoutManager;
var
    RowLayoutItem: TBoxLayoutManager;
begin

  Result := inherited CreateLayoutManager;

  Result.RemoveLayoutItem(DocumentNumberPrefixEdit.Name); { refactor: prefix-postfixed or n-number parts number }
  
  Result.InsertControlAfter(PersonnelOrderSubKindLabel, DocumentTypeLabel.Name);

  with
    TBoxedLayoutItemVisualSettingsHolder(
      Result.FindVisualSettingsHolderByLayoutItemId(
        PersonnelOrderSubKindLabel.Name
      )
    )
  do Gap := 8;

  RowLayoutItem :=
    THorizontalBoxLayoutManager(
      THorizontalBoxLayoutManagerBuilder.Create.AddControls(
        [
          PersonnelOrderSubKindChooseButton,
          PersonnelOrderSubKindEdit
        ],
        [-1, 5]
      )
      .SetId('PersonnelOrderSubKindRow')
      .BuildAndDestroy
    );

  Result.InsertLayoutManagerAfter(RowLayoutItem, 'DocumentTypeRow');

  with
    TBoxedLayoutItemVisualSettingsHolder(
      Result.FindVisualSettingsHolderFor(RowLayoutItem)
    )
  do Gap := 8;

end;

function TPersonnelOrderMainInformationFrame.GetDocumentSignerSetHolder: TEmployeeSetHolder;
var
    PersonnelOrderSignerSetReadService: IPersonnelOrderSignerSetReadService;
begin

  PersonnelOrderSignerSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetPersonnelOrderPresentationServiceRegistry
            .GetPersonnelOrderSignerSetReadService;

  Result := PersonnelOrderSignerSetReadService.GetPersonnelOrderSignerSet;
  
end;

function TPersonnelOrderMainInformationFrame.
  GetPersonnelOrderMainInformationFormViewModel: TPersonnelOrderMainInformationFormViewModel;
begin

  Result := GetViewModel as TPersonnelOrderMainInformationFormViewModel;

end;

procedure TPersonnelOrderMainInformationFrame.SetPersonnelOrderMainInformationFormViewModel(
  const Value: TPersonnelOrderMainInformationFormViewModel);
begin

  SetViewModel(Value);

end;

procedure TPersonnelOrderMainInformationFrame.SetViewModel(
  ViewModel: TDocumentMainInformationFormViewModel
);
begin

  inherited SetViewModel(ViewModel);

  with ViewModel as TPersonnelOrderMainInformationFormViewModel do begin

    PersonnelOrderSubKindEdit.Text := SubKindName;

  end;

end;

end.
