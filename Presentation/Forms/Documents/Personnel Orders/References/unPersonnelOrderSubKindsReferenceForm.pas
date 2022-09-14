unit unPersonnelOrderSubKindsReferenceForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DocumentFlowBaseReferenceFormUnit, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Menus, dxSkinsCore, dxSkinsDefaultPainters, cxControls,
  cxStyles, dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage,
  cxEdit, DB, cxDBData, cxLocalization, ActnList, ImgList, PngImageList,
  cxGridLevel, cxClasses, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, ComCtrls, ExtCtrls, StdCtrls,
  cxButtons, ToolWin, PersonnelOrderSubKindSetHolder,
  PersonnelOrderSubKindSetReadService, PersonnelOrderSubKindViewModel,
  DBDataTableFormUnit;

type

  TOnPersonnelOrderSubKindsSelectedEventHandler =
    procedure (
      Sender: TObject;
      SelectedSubKinds: TPersonnelOrderSubKindViewModels
    ) of object;
    
  TPersonnelOrderSubKindsReferenceForm = class(TDocumentFlowBaseReferenceForm)
    IdColumn: TcxGridDBColumn;
    NameColumn: TcxGridDBColumn;
  private

    FPersonnelOrderSubKindSetHolder: TPersonnelOrderSubKindSetHolder;

    procedure SetTableColumnLayoutFrom(PersonnelOrderSubKindSetHolder: TPersonnelOrderSubKindSetHolder);
    procedure UpdateTableViewFrom(PersonnelOrderSubKindSetHolder: TPersonnelOrderSubKindSetHolder);
    function GetPersonnelOrderSubKindSetHolder: TPersonnelOrderSubKindSetHolder;
    procedure SetPersonnelOrderSubKindSetHolder(
      const Value: TPersonnelOrderSubKindSetHolder);

  private

    FOnPersonnelOrderSubKindsSelectedEventHandler: TOnPersonnelOrderSubKindsSelectedEventHandler;
    
    function GetSelectedPersonnelOrderSubKinds: TPersonnelOrderSubKindViewModels;

  protected

    procedure Init(
      const Caption: String = ''; ADataSet:
      TDataSet = nil
    ); override;

    procedure OnRefreshRecords; override;

    function GetTotalRecordCountPanelLabel: String; override;
    
  protected

    procedure HandleRecordsChoosedEvent(
      Sender: TObject;
      SelectedRecrods: TDBDataTableRecords
    );

  public

    property SelectedPersonnelOrderSubKinds: TPersonnelOrderSubKindViewModels
    read GetSelectedPersonnelOrderSubKinds;
    
    property OnPersonnelOrderSubKindsSelectedEventHandler: TOnPersonnelOrderSubKindsSelectedEventHandler
    read FOnPersonnelOrderSubKindsSelectedEventHandler
    write FOnPersonnelOrderSubKindsSelectedEventHandler;
    
    property PersonnelOrderSubKindSetHolder: TPersonnelOrderSubKindSetHolder
    read GetPersonnelOrderSubKindSetHolder
    write SetPersonnelOrderSubKindSetHolder;

  end;

var
  PersonnelOrderSubKindsReferenceForm: TPersonnelOrderSubKindsReferenceForm;

implementation

uses

  ApplicationServiceRegistries, PresentationServiceRegistry,
  PersonnelOrderPresentationServiceRegistry;
  
{$R *.dfm}

{ TPersonnelOrderSubKindsReferenceForm }

function TPersonnelOrderSubKindsReferenceForm.
  GetSelectedPersonnelOrderSubKinds: TPersonnelOrderSubKindViewModels;
var
    SelectedRecord: TDBDataTableRecord;
    SubKindViewModel: TPersonnelOrderSubKindViewModel;
begin

  if not Assigned(SelectedRecords) then begin

    Result := nil;
    Exit;

  end;

  Result := TPersonnelOrderSubKindViewModels.Create;

  try

    for SelectedRecord in SelectedRecords do begin

      SubKindViewModel := TPersonnelOrderSubKindViewModel.Create;

      SubKindViewModel.Id := SelectedRecord[IdColumn.DataBinding.FieldName];
      SubKindViewModel.Name := SelectedRecord[NameColumn.DataBinding.FieldName];

      Result.Add(SubKindViewModel);
      
    end;

  except

    FreeAndNil(Result);

    Raise;

  end;
  
end;

function TPersonnelOrderSubKindsReferenceForm.GetTotalRecordCountPanelLabel: String;
begin

  Result := 'Количество подтипов: ';
  
end;

procedure TPersonnelOrderSubKindsReferenceForm.HandleRecordsChoosedEvent(
  Sender: TObject;
  SelectedRecrods: TDBDataTableRecords
);
var
    SelectedRecord: TDBDataTableRecord;
    SubKindViewModels: TPersonnelOrderSubKindViewModels;
    SubKindViewModel: TPersonnelOrderSubKindViewModel;
begin

  if not Assigned(FOnPersonnelOrderSubKindsSelectedEventHandler) then Exit;

  SubKindViewModels := SelectedPersonnelOrderSubKinds;

  try

    FOnPersonnelOrderSubKindsSelectedEventHandler(Self, SubKindViewModels);
    
  finally

    FreeAndNil(SubKindViewModels);
    
  end;

end;

procedure TPersonnelOrderSubKindsReferenceForm.Init(const Caption: String;
  ADataSet: TDataSet);
begin

  inherited;

  OnRecordsChoosedEventHandler := HandleRecordsChoosedEvent;

end;

procedure TPersonnelOrderSubKindsReferenceForm.OnRefreshRecords;
var
    PersonnelOrderSubKindSetReadService: IPersonnelOrderSubKindSetReadService;
    PersonnelOrderSubKindSetHolder: TPersonnelOrderSubKindSetHolder;
begin

  PersonnelOrderSubKindSetReadService :=
    TApplicationServiceRegistries
      .Current
        .GetPresentationServiceRegistry
          .GetPersonnelOrderPresentationServiceRegistry
            .GetPersonnelOrderSubKindSetReadService;

  try

    Screen.Cursor := crHourGlass;

    PersonnelOrderSubKindSetHolder :=
      PersonnelOrderSubKindSetReadService.GetPersonnelOrderSubKindSet;

    try

      Self.PersonnelOrderSubKindSetHolder := PersonnelOrderSubKindSetHolder;

    except

      FreeAndNil(PersonnelOrderSubKindSetHolder);

      Raise;

    end;

  finally

    UpdateMainUI;
    
    Screen.Cursor := crDefault;

  end;

end;

function TPersonnelOrderSubKindsReferenceForm.GetPersonnelOrderSubKindSetHolder: TPersonnelOrderSubKindSetHolder;
begin

  Result := FPersonnelOrderSubKindSetHolder;

end;

procedure TPersonnelOrderSubKindsReferenceForm.SetPersonnelOrderSubKindSetHolder(
  const Value: TPersonnelOrderSubKindSetHolder);
begin

  if FPersonnelOrderSubKindSetHolder = Value then Exit;

  FreeAndNil(FPersonnelOrderSubKindSetHolder);

  FPersonnelOrderSubKindSetHolder := Value;

  UpdateTableViewFrom(FPersonnelOrderSubKindSetHolder);

end;

procedure TPersonnelOrderSubKindsReferenceForm.SetTableColumnLayoutFrom(
  PersonnelOrderSubKindSetHolder: TPersonnelOrderSubKindSetHolder);
begin

  with PersonnelOrderSubKindSetHolder.FieldDefs do begin

    IdColumn.DataBinding.FieldName := IdFieldName;
    NameColumn.DataBinding.FieldName := NameFieldName;

  end;
end;

procedure TPersonnelOrderSubKindsReferenceForm.UpdateTableViewFrom(
  PersonnelOrderSubKindSetHolder: TPersonnelOrderSubKindSetHolder);
begin

  SetTableColumnLayoutFrom(PersonnelOrderSubKindSetHolder);
  
  DataSet := PersonnelOrderSubKindSetHolder.DataSet;
  
end;

end.
