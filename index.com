<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestão de Jogos - Futsal, Society e Futebol</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            color: #333;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .screen {
            display: none;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            padding: 30px;
            margin-bottom: 20px;
        }

        .screen.active {
            display: block;
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
            font-size: 2.5em;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.1);
        }

        h2 {
            color: #34495e;
            margin-bottom: 20px;
            font-size: 1.8em;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #2c3e50;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: border-color 0.3s;
        }

        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #3498db;
        }

        .btn {
            background: linear-gradient(45deg, #e74c3c, #c0392b);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-block;
            text-decoration: none;
            text-align: center;
            margin: 5px;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        .btn-primary {
            background: linear-gradient(45deg, #3498db, #2980b9);
        }

        .btn-success {
            background: linear-gradient(45deg, #27ae60, #229954);
        }

        .btn-warning {
            background: linear-gradient(45deg, #f39c12, #e67e22);
        }

        .btn-danger {
            background: linear-gradient(45deg, #e74c3c, #c0392b);
        }

        .teams-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-top: 20px;
        }

        .team-card {
            background: #f8f9fa;
            border: 3px solid #dee2e6;
            border-radius: 15px;
            padding: 20px;
            transition: all 0.3s;
        }

        .team-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .team-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }

        .team-name {
            font-size: 1.2em;
            font-weight: bold;
            color: #2c3e50;
        }

        .player-count {
            background: #3498db;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.9em;
        }

        .players-list {
            max-height: 200px;
            overflow-y: auto;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 10px;
            margin-top: 10px;
        }

        .player-item {
            background: #e8f4f8;
            padding: 8px 12px;
            margin: 5px 0;
            border-radius: 5px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .game-screen {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 20px;
            border-radius: 15px;
        }

        .game-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }

        .timer {
            font-size: 3em;
            font-weight: bold;
            text-align: center;
            margin: 20px 0;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }

        .scoreboard {
            display: grid;
            grid-template-columns: 1fr auto 1fr;
            gap: 20px;
            align-items: center;
            margin: 30px 0;
        }

        .team-score {
            text-align: center;
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 15px;
            backdrop-filter: blur(10px);
        }

        .team-score h3 {
            font-size: 1.5em;
            margin-bottom: 10px;
        }

        .score {
            font-size: 4em;
            font-weight: bold;
            text-shadow: 3px 3px 6px rgba(0,0,0,0.3);
        }

        .vs {
            font-size: 2em;
            font-weight: bold;
            text-align: center;
        }

        .game-controls {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            justify-content: center;
            margin: 30px 0;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            backdrop-filter: blur(5px);
        }

        .modal-content {
            background: white;
            margin: 5% auto;
            padding: 20px;
            border-radius: 15px;
            width: 95%;
            max-width: 800px;
            max-height: 85vh;
            overflow-y: auto;
            color: #333;
            position: relative;
        }

        .close {
            color: #aaa;
            position: absolute;
            top: 15px;
            right: 20px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
            z-index: 10;
        }

        .close:hover {
            color: #000;
        }

        .player-selection {
            margin: 20px 0;
        }

        .player-option {
            display: flex;
            align-items: center;
            margin: 10px 0;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 5px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        .player-option:hover {
            background-color: #e9ecef;
        }

        .player-option input {
            margin-right: 10px;
            width: auto;
        }

        .history {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            max-height: 300px;
            overflow-y: auto;
        }

        .history-item {
            background: rgba(255,255,255,0.1);
            padding: 10px;
            margin: 5px 0;
            border-radius: 5px;
            border-left: 4px solid #f39c12;
        }

        .teams-display {
            background: rgba(255,255,255,0.1);
            padding: 20px;
            border-radius: 10px;
            margin: 20px 0;
        }

        .teams-display .team-card {
            background: rgba(255,255,255,0.95);
            color: #333333;
        }

        .teams-display .team-name {
            color: #2c3e50;
        }

        .teams-display .player-count {
            background: #3498db;
            color: white;
        }

        .teams-display .player-stats {
            background: rgba(248,249,250,0.9);
            color: #333333;
        }

        .teams-display .player-stats.has-stats {
            background: rgba(46, 204, 113, 0.9);
            color: #ffffff;
        }

        .teams-display .stat-item {
            background: rgba(52, 152, 219, 0.8);
            color: #ffffff;
        }

        .player-stats {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 12px;
            margin: 5px 0;
            border-radius: 5px;
            background: rgba(255,255,255,0.1);
        }

        .player-stats.has-stats {
            background: rgba(46, 204, 113, 0.2);
            border-left: 4px solid #2ecc71;
        }

        .stats-info {
            display: flex;
            gap: 15px;
            font-size: 0.9em;
        }

        .team-selector {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin: 20px 0;
        }

        .team-option {
            background: #f8f9fa;
            border: 3px solid #dee2e6;
            border-radius: 10px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .team-option:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .team-option.selected {
            border-color: #3498db;
            background: #e8f4f8;
        }

        .whatsapp-btn {
            background: linear-gradient(45deg, #25d366, #128c7e);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 25px;
            font-size: 14px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .whatsapp-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            .screen {
                padding: 20px;
            }

            h1 {
                font-size: 2em;
            }

            .timer {
                font-size: 2em;
            }

            .score {
                font-size: 3em;
            }

            .game-controls {
                flex-direction: column;
                align-items: stretch;
            }

            .btn {
                width: 100%;
                margin: 5px 0;
            }

            .scoreboard {
                grid-template-columns: 1fr;
                gap: 10px;
            }

            .vs {
                order: 2;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Tela 1: Configuração Inicial -->
        <div id="setup-screen" class="screen active">
            <h1>⚽ Gestão de Jogos</h1>
            <h2>Configuração Inicial</h2>
            
            <div class="form-group">
                <label for="team-count">Quantos times irão jogar?</label>
                <select id="team-count">
                    <option value="2">2 times</option>
                    <option value="3">3 times</option>
                    <option value="4">4 times</option>
                    <option value="5">5 times</option>
                    <option value="6">6 times</option>
                </select>
            </div>

            <div class="form-group">
                <label for="players-per-team">Quantos jogadores por time?</label>
                <select id="players-per-team" onchange="handlePlayersPerTeamChange()">
                    <option value="5">5 jogadores (Futsal)</option>
                    <option value="7">7 jogadores (Society)</option>
                    <option value="11">11 jogadores (Futebol)</option>
                    <option value="custom">Personalizado</option>
                </select>
            </div>

            <div class="form-group" id="custom-players-group" style="display: none;">
                <label for="custom-players-count">Quantidade personalizada de jogadores:</label>
                <select id="custom-players-count">
                    <option value="2">2 jogadores</option>
                    <option value="3">3 jogadores</option>
                    <option value="4">4 jogadores</option>
                    <option value="5">5 jogadores</option>
                    <option value="6">6 jogadores</option>
                    <option value="7">7 jogadores</option>
                    <option value="8">8 jogadores</option>
                    <option value="9">9 jogadores</option>
                    <option value="10">10 jogadores</option>
                    <option value="11">11 jogadores</option>
                    <option value="12">12 jogadores</option>
                    <option value="13">13 jogadores</option>
                    <option value="14">14 jogadores</option>
                    <option value="15">15 jogadores</option>
                    <option value="16">16 jogadores</option>
                    <option value="17">17 jogadores</option>
                    <option value="18">18 jogadores</option>
                    <option value="19">19 jogadores</option>
                    <option value="20">20 jogadores</option>
                </select>
            </div>

            <button class="btn btn-primary" onclick="setupTeams()">Próximo</button>
        </div>

        <!-- Tela 2: Configuração dos Times -->
        <div id="teams-screen" class="screen">
            <h1>⚽ Configuração dos Times</h1>
            <div id="teams-container" class="teams-grid"></div>
            <div style="text-align: center; margin-top: 30px;">
                <button class="btn btn-success" onclick="finishTeamSetup()">Finalizar Configuração</button>
            </div>
        </div>

        <!-- Tela 3: Compartilhamento WhatsApp -->
        <div id="whatsapp-screen" class="screen">
            <h1>📱 Compartilhar Times</h1>
            <div id="teams-summary"></div>
            <div style="text-align: center; margin-top: 30px;">
                <button class="whatsapp-btn" onclick="shareWhatsApp()">
                    📱 Compartilhar no WhatsApp
                </button>
                <button class="btn btn-primary" onclick="goToGameSelection()">Pular e Continuar</button>
            </div>
        </div>

        <!-- Tela 4: Seleção de Times para Jogo -->
        <div id="game-selection-screen" class="screen">
            <h1>🎮 Selecionar Times para Jogo</h1>
            <h2>Escolha os 2 times que irão jogar:</h2>
            <div id="team-selector" class="team-selector"></div>
            <div style="text-align: center; margin-top: 30px;">
                <button class="btn btn-success" onclick="startGame()">Iniciar Jogo</button>
            </div>
        </div>

        <!-- Tela 5: Jogo em Andamento -->
        <div id="game-screen" class="screen">
            <div class="game-screen">
                <div class="game-header">
                    <h1>🎮 Jogo em Andamento</h1>
                    <button class="btn btn-danger" onclick="endGame()">Encerrar Jogo</button>
                </div>

                <div class="timer" id="timer">00:00</div>
                
                <div class="scoreboard">
                    <div class="team-score">
                        <h3 id="team1-name">Time 1</h3>
                        <div class="score" id="team1-score">0</div>
                    </div>
                    <div class="vs">VS</div>
                    <div class="team-score">
                        <h3 id="team2-name">Time 2</h3>
                        <div class="score" id="team2-score">0</div>
                    </div>
                </div>

                <div class="game-controls">
                    <button class="btn btn-success" id="timer-btn" onclick="toggleTimer()">▶️ Iniciar</button>
                    <button class="btn btn-primary" onclick="openGoalModal()">⚽ GOOOL</button>
                    <button class="btn btn-danger" onclick="openOwnGoalModal()">🔴 GOOL CONTRA</button>
                    <button class="btn btn-warning" onclick="openPlayerManagement()">👥 Alterar Jogadores</button>
                </div>

                <div class="teams-display">
                    <h3>👥 Times e Estatísticas</h3>
                    <div class="teams-grid" id="teams-stats-display"></div>
                </div>

                <div class="history">
                    <h3>📋 Histórico do Jogo</h3>
                    <div id="game-history"></div>
                </div>
            </div>
        </div>

        <!-- Tela 6: Relatório Final -->
        <div id="final-report-screen" class="screen">
            <h1>📊 Relatório Final</h1>
            <div id="final-report-content"></div>
            <div style="text-align: center; margin-top: 30px;">
                <button class="whatsapp-btn" onclick="shareFinalReport()">
                    📱 Compartilhar Relatório
                </button>
                <button class="btn btn-primary" onclick="newGame()">🎮 Novo Jogo</button>
                <button class="btn btn-success" onclick="goToGameSelection()">⚽ Próxima Partida</button>
            </div>
        </div>
    </div>

    <!-- Modal para Gol -->
    <div id="goal-modal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeGoalModal()">&times;</span>
            <h2 style="margin-top: 40px;">⚽ Registrar Gol</h2>
            
            <div class="teams-grid">
                <div class="team-card" style="max-height: 300px; overflow-y: auto;">
                    <div class="team-header">
                        <div class="team-name" id="goal-team1-name">Time 1</div>
                        <button class="btn btn-primary" onclick="selectGoalTeam('team1')">Selecionar Time</button>
                    </div>
                    <div id="goal-team1-players" class="player-selection"></div>
                </div>
                
                <div class="team-card" style="max-height: 300px; overflow-y: auto;">
                    <div class="team-header">
                        <div class="team-name" id="goal-team2-name">Time 2</div>
                        <button class="btn btn-primary" onclick="selectGoalTeam('team2')">Selecionar Time</button>
                    </div>
                    <div id="goal-team2-players" class="player-selection"></div>
                </div>
            </div>
            
            <div class="form-group" id="assist-section" style="display: none;">
                <label>Quem deu assistência? (opcional)</label>
                <select id="assist-player-select">
                    <option value="">Nenhuma assistência</option>
                </select>
            </div>
            
            <div style="text-align: center; margin-top: 20px;">
                <button class="btn btn-success" onclick="registerGoal()">Registrar Gol</button>
            </div>
        </div>
    </div>

    <!-- Modal para Gol Contra -->
    <div id="own-goal-modal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeOwnGoalModal()">&times;</span>
            <h2>🔴 Registrar Gol Contra</h2>
            <div class="form-group">
                <label>Selecione o time que fez o gol contra:</label>
                <select id="own-goal-team">
                    <option value="team1">Time 1</option>
                    <option value="team2">Time 2</option>
                </select>
            </div>
            <div class="form-group">
                <label>Quem fez o gol contra?</label>
                <div id="own-goal-players" class="player-selection"></div>
            </div>
            <button class="btn btn-danger" onclick="registerOwnGoal()">Registrar Gol Contra</button>
        </div>
    </div>

    <!-- Modal para Gestão de Jogadores -->
    <div id="player-management-modal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closePlayerManagement()">&times;</span>
            <h2>👥 Gestão de Jogadores</h2>
            <div class="form-group">
                <label>Ação:</label>
                <select id="player-action">
                    <option value="add">Adicionar Jogador</option>
                    <option value="remove">Remover Jogador</option>
                    <option value="swap">Trocar Jogadores</option>
                </select>
            </div>
            <div id="player-action-content"></div>
            <button class="btn btn-success" onclick="executePlayerAction()">Executar Ação</button>
        </div>
    </div>

    <script>
        // Variáveis globais
        let gameState = {
            teams: [],
            currentGame: null,
            timer: { minutes: 0, seconds: 0, running: false },
            timerInterval: null,
            history: [],
            teamCount: 2,
            playersPerTeam: 5,
            selectedTeams: []
        };

        // Cores para times automáticos
        const teamColors = ['Vermelho', 'Azul', 'Verde', 'Amarelo', 'Laranja', 'Roxo', 'Rosa', 'Marrom'];

        // Funções de persistência
        function saveGameState() {
            localStorage.setItem('soccerGameState', JSON.stringify(gameState));
            localStorage.setItem('currentScreen', getCurrentScreen());
        }

        function loadGameState() {
            const saved = localStorage.getItem('soccerGameState');
            if (saved) {
                gameState = JSON.parse(saved);
                const currentScreen = localStorage.getItem('currentScreen');
                if (currentScreen) {
                    showScreen(currentScreen);
                    restoreScreenState(currentScreen);
                }
            }
        }

        function getCurrentScreen() {
            const screens = document.querySelectorAll('.screen');
            for (let screen of screens) {
                if (screen.classList.contains('active')) {
                    return screen.id;
                }
            }
            return 'setup-screen';
        }

        function restoreScreenState(screenId) {
            switch (screenId) {
                case 'teams-screen':
                    document.getElementById('team-count').value = gameState.teamCount;
                    const playersSelect = document.getElementById('players-per-team');
                    const customGroup = document.getElementById('custom-players-group');
                    
                    // Verificar se é um valor personalizado
                    const standardValues = ['5', '7', '11'];
                    if (standardValues.includes(gameState.playersPerTeam.toString())) {
                        playersSelect.value = gameState.playersPerTeam;
                        customGroup.style.display = 'none';
                    } else {
                        playersSelect.value = 'custom';
                        customGroup.style.display = 'block';
                        document.getElementById('custom-players-count').value = gameState.playersPerTeam;
                    }
                    
                    setupTeams();
                    break;
                case 'whatsapp-screen':
                    showTeamsSummary();
                    break;
                case 'game-selection-screen':
                    populateTeamSelector();
                    break;
                case 'game-screen':
                    if (gameState.currentGame) {
                        restoreGameScreen();
                    }
                    break;
                case 'final-report-screen':
                    generateFinalReport();
                    break;
            }
        }

        function restoreGameScreen() {
            const game = gameState.currentGame;
            if (!game) return;
            
            // Garantir que as estatísticas existam
            if (!game.stats) {
                game.stats = { team1: {}, team2: {} };
                
                if (game.team1 && game.team1.players) {
                    game.team1.players.forEach(player => {
                        game.stats.team1[player] = { goals: 0, assists: 0 };
                    });
                }
                
                if (game.team2 && game.team2.players) {
                    game.team2.players.forEach(player => {
                        game.stats.team2[player] = { goals: 0, assists: 0 };
                    });
                }
            }
            
            document.getElementById('team1-name').textContent = game.team1.name;
            document.getElementById('team2-name').textContent = game.team2.name;
            document.getElementById('team1-score').textContent = game.score.team1;
            document.getElementById('team2-score').textContent = game.score.team2;
            updateTimer();
            updateTimerButton();
            updateGameHistory();
            updateTeamsDisplay();
            if (gameState.timer.running) {
                startTimerInterval();
            }
        }

        // Função para atualizar o estado do botão do timer
        function updateTimerButton() {
            const timerBtn = document.getElementById('timer-btn');
            if (gameState.timer.running) {
                timerBtn.innerHTML = '⏸️ Pausar';
            } else {
                if (gameState.timer.minutes === 0 && gameState.timer.seconds === 0) {
                    timerBtn.innerHTML = '▶️ Iniciar';
                } else {
                    timerBtn.innerHTML = '▶️ Continuar';
                }
            }
        }

        // Atualizar display dos times e estatísticas
        function updateTeamsDisplay() {
            const container = document.getElementById('teams-stats-display');
            if (!container || !gameState.currentGame) return;
            
            const game = gameState.currentGame;
            
            // Verificar se as estatísticas existem, se não, inicializar
            if (!game.stats) {
                game.stats = { team1: {}, team2: {} };
                
                // Inicializar estatísticas para todos os jogadores
                if (game.team1 && game.team1.players) {
                    game.team1.players.forEach(player => {
                        game.stats.team1[player] = { goals: 0, assists: 0 };
                    });
                }
                
                if (game.team2 && game.team2.players) {
                    game.team2.players.forEach(player => {
                        game.stats.team2[player] = { goals: 0, assists: 0 };
                    });
                }
            }
            
            // Verificar se os times existem
            if (!game.team1 || !game.team2) return;
            
            container.innerHTML = `
                <div class="team-card">
                    <div class="team-header">
                        <div class="team-name">${game.team1.name}</div>
                        <div class="player-count">${game.team1.players ? game.team1.players.length : 0} jogadores</div>
                    </div>
                    <div class="players-list">
                        ${game.team1.players ? game.team1.players.map(player => {
                            const stats = game.stats.team1[player] || { goals: 0, assists: 0 };
                            const hasStats = stats.goals > 0 || stats.assists > 0;
                            return `
                                <div class="player-stats ${hasStats ? 'has-stats' : ''}">
                                    <span>${player}</span>
                                    <div class="stats-info">
                                        ${stats.goals > 0 ? `<span class="stat-item">⚽ ${stats.goals}</span>` : ''}
                                        ${stats.assists > 0 ? `<span class="stat-item">🅰️ ${stats.assists}</span>` : ''}
                                    </div>
                                </div>
                            `;
                        }).join('') : ''}
                    </div>
                </div>
                
                <div class="team-card">
                    <div class="team-header">
                        <div class="team-name">${game.team2.name}</div>
                        <div class="player-count">${game.team2.players ? game.team2.players.length : 0} jogadores</div>
                    </div>
                    <div class="players-list">
                        ${game.team2.players ? game.team2.players.map(player => {
                            const stats = game.stats.team2[player] || { goals: 0, assists: 0 };
                            const hasStats = stats.goals > 0 || stats.assists > 0;
                            return `
                                <div class="player-stats ${hasStats ? 'has-stats' : ''}">
                                    <span>${player}</span>
                                    <div class="stats-info">
                                        ${stats.goals > 0 ? `<span class="stat-item">⚽ ${stats.goals}</span>` : ''}
                                        ${stats.assists > 0 ? `<span class="stat-item">🅰️ ${stats.assists}</span>` : ''}
                                    </div>
                                </div>
                            `;
                        }).join('') : ''}
                    </div>
                </div>
            `;
        }

        // Funções de navegação
        function showScreen(screenId) {
            const screens = document.querySelectorAll('.screen');
            screens.forEach(screen => screen.classList.remove('active'));
            document.getElementById(screenId).classList.add('active');
        }

        // Configuração inicial
        function handlePlayersPerTeamChange() {
            const playersPerTeam = document.getElementById('players-per-team').value;
            const customGroup = document.getElementById('custom-players-group');
            
            if (playersPerTeam === 'custom') {
                customGroup.style.display = 'block';
            } else {
                customGroup.style.display = 'none';
            }
        }

        function setupTeams() {
            const playersPerTeamSelect = document.getElementById('players-per-team').value;
            
            if (playersPerTeamSelect === 'custom') {
                gameState.playersPerTeam = parseInt(document.getElementById('custom-players-count').value);
            } else {
                gameState.playersPerTeam = parseInt(playersPerTeamSelect);
            }
            
            gameState.teamCount = parseInt(document.getElementById('team-count').value);
            
            // Inicializar times se não existirem
            if (gameState.teams.length === 0) {
                gameState.teams = [];
                for (let i = 0; i < gameState.teamCount; i++) {
                    gameState.teams.push({
                        id: i,
                        name: `Time ${teamColors[i] || i + 1}`,
                        players: []
                    });
                }
            }
            
            renderTeamsSetup();
            showScreen('teams-screen');
            saveGameState();
        }

        function renderTeamsSetup() {
            const container = document.getElementById('teams-container');
            container.innerHTML = '';
            
            gameState.teams.forEach((team, index) => {
                const teamCard = document.createElement('div');
                teamCard.className = 'team-card';
                teamCard.innerHTML = `
                    <div class="team-header">
                        <input type="text" value="${team.name}" onchange="updateTeamName(${index}, this.value)" 
                               class="team-name" style="border: none; background: transparent; font-size: 1.2em; font-weight: bold;">
                        <div class="player-count" id="player-count-${index}">${team.players.length}/${gameState.playersPerTeam}</div>
                    </div>
                    <div class="form-group">
                        <textarea placeholder="Digite os nomes dos jogadores (um por linha)" 
                                  onchange="updateTeamPlayers(${index}, this.value)"
                                  oninput="updatePlayersCount(${index}, this.value)"
                                  rows="6" id="players-textarea-${index}">${team.players.join('\n')}</textarea>
                    </div>
                `;
                container.appendChild(teamCard);
            });
        }

        function updateTeamName(teamIndex, name) {
            gameState.teams[teamIndex].name = name || `Time ${teamColors[teamIndex] || teamIndex + 1}`;
            saveGameState();
        }

        function updatePlayersCount(teamIndex, playersText) {
            const players = playersText.split('\n').filter(p => p.trim().length > 0);
            const countElement = document.getElementById(`player-count-${teamIndex}`);
            
            if (countElement) {
                countElement.textContent = `${players.length}/${gameState.playersPerTeam}`;
                countElement.style.backgroundColor = players.length === gameState.playersPerTeam ? '#27ae60' : '#3498db';
            }
        }

        function updateTeamPlayers(teamIndex, playersText) {
            const players = playersText.split('\n').filter(p => p.trim().length > 0);
            gameState.teams[teamIndex].players = players;
            updatePlayersCount(teamIndex, playersText);
            saveGameState();
        }

        function finishTeamSetup() {
            // Validar se todos os times têm jogadores
            const incompleteTeams = gameState.teams.filter(team => team.players.length === 0);
            if (incompleteTeams.length > 0) {
                alert('Todos os times devem ter pelo menos 1 jogador!');
                return;
            }
            
            showTeamsSummary();
            showScreen('whatsapp-screen');
            saveGameState();
        }

        function showTeamsSummary() {
            const container = document.getElementById('teams-summary');
            container.innerHTML = '<h2>Times Configurados:</h2>';
            
            gameState.teams.forEach(team => {
                const teamDiv = document.createElement('div');
                teamDiv.className = 'team-card';
                teamDiv.innerHTML = `
                    <div class="team-header">
                        <div class="team-name">${team.name}</div>
                        <div class="player-count">${team.players.length} jogadores</div>
                    </div>
                    <div class="players-list">
                        ${team.players.map(player => `<div class="player-item">${player}</div>`).join('')}
                    </div>
                `;
                container.appendChild(teamDiv);
            });
        }

        function shareWhatsApp() {
            let message = "⚽ *TIMES ESCALADOS* ⚽\n\n";
            
            gameState.teams.forEach(team => {
                message += `🔹 *${team.name}*\n`;
                team.players.forEach(player => {
                    message += `   • ${player}\n`;
                });
                message += '\n';
            });
            
            message += "Bom jogo para todos! 🎉";
            
            const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(message)}`;
            window.open(whatsappUrl, '_blank');
            
            // Simular retorno automático após 3 segundos
            setTimeout(() => {
                goToGameSelection();
            }, 3000);
        }

        function goToGameSelection() {
            // Se houver apenas 2 times, pular seleção e ir direto para o jogo
            if (gameState.teamCount === 2) {
                gameState.selectedTeams = [0, 1]; // Selecionar automaticamente os 2 primeiros times
                startGame();
                return;
            }
            
            populateTeamSelector();
            showScreen('game-selection-screen');
            saveGameState();
        }

        function populateTeamSelector() {
            const container = document.getElementById('team-selector');
            container.innerHTML = '';
            
            gameState.teams.forEach(team => {
                const teamOption = document.createElement('div');
                teamOption.className = 'team-option';
                teamOption.onclick = () => selectTeam(team.id);
                teamOption.innerHTML = `
                    <h3>${team.name}</h3>
                    <p>${team.players.length} jogadores</p>
                `;
                teamOption.id = `team-option-${team.id}`;
                container.appendChild(teamOption);
            });
        }

        function selectTeam(teamId) {
            const option = document.getElementById(`team-option-${teamId}`);
            
            if (gameState.selectedTeams.includes(teamId)) {
                // Deselecionar
                gameState.selectedTeams = gameState.selectedTeams.filter(id => id !== teamId);
                option.classList.remove('selected');
            } else if (gameState.selectedTeams.length < 2) {
                // Selecionar
                gameState.selectedTeams.push(teamId);
                option.classList.add('selected');
            } else {
                alert('Você já selecionou 2 times!');
            }
            
            saveGameState();
        }

        function startGame() {
            if (gameState.selectedTeams.length !== 2) {
                alert('Selecione exatamente 2 times para jogar!');
                return;
            }
            
            const team1 = gameState.teams.find(t => t.id === gameState.selectedTeams[0]);
            const team2 = gameState.teams.find(t => t.id === gameState.selectedTeams[1]);
            
            gameState.currentGame = {
                team1: JSON.parse(JSON.stringify(team1)),
                team2: JSON.parse(JSON.stringify(team2)),
                score: { team1: 0, team2: 0 },
                stats: {
                    team1: {},
                    team2: {}
                }
            };
            
            // Inicializar estatísticas dos jogadores
            team1.players.forEach(player => {
                gameState.currentGame.stats.team1[player] = { goals: 0, assists: 0 };
            });
            team2.players.forEach(player => {
                gameState.currentGame.stats.team2[player] = { goals: 0, assists: 0 };
            });
            
            gameState.timer = { minutes: 0, seconds: 0, running: false };
            gameState.history = [];
            
            document.getElementById('team1-name').textContent = team1.name;
            document.getElementById('team2-name').textContent = team2.name;
            document.getElementById('team1-score').textContent = '0';
            document.getElementById('team2-score').textContent = '0';
            document.getElementById('timer').textContent = '00:00';
            document.getElementById('game-history').innerHTML = '';
            
            updateTeamsDisplay();
            showScreen('game-screen');
            saveGameState();
        }

        // Funções do timer
        function toggleTimer() {
            if (gameState.timer.running) {
                pauseTimer();
            } else {
                startTimer();
            }
        }

        function startTimer() {
            gameState.timer.running = true;
            updateTimerButton();
            startTimerInterval();
            addToHistory(`⏱️ Timer iniciado aos ${formatTime(gameState.timer)}`);
            saveGameState();
        }

        function pauseTimer() {
            gameState.timer.running = false;
            if (gameState.timerInterval) {
                clearInterval(gameState.timerInterval);
            }
            updateTimerButton();
            addToHistory(`⏸️ Timer pausado aos ${formatTime(gameState.timer)}`);
            saveGameState();
        }

        function startTimerInterval() {
            if (gameState.timerInterval) {
                clearInterval(gameState.timerInterval);
            }
            
            gameState.timerInterval = setInterval(() => {
                gameState.timer.seconds++;
                if (gameState.timer.seconds >= 60) {
                    gameState.timer.minutes++;
                    gameState.timer.seconds = 0;
                }
                updateTimer();
                saveGameState();
            }, 1000);
        }

        function resetTimer() {
            if (confirm('Tem certeza que deseja resetar o timer?')) {
                gameState.timer = { minutes: 0, seconds: 0, running: false };
                if (gameState.timerInterval) {
                    clearInterval(gameState.timerInterval);
                }
                updateTimerButton();
                updateTimer();
                addToHistory('🔄 Timer resetado');
                saveGameState();
            }
        }

        function updateTimer() {
            document.getElementById('timer').textContent = formatTime(gameState.timer);
        }

        function formatTime(timer) {
            const minutes = String(timer.minutes).padStart(2, '0');
            const seconds = String(timer.seconds).padStart(2, '0');
            return `${minutes}:${seconds}`;
        }

        // Funções de gol
        let selectedGoalTeam = null;
        let selectedGoalPlayer = null;

        function openGoalModal() {
            selectedGoalTeam = null;
            selectedGoalPlayer = null;
            populateGoalModal();
            document.getElementById('goal-modal').style.display = 'block';
        }

        function closeGoalModal() {
            document.getElementById('goal-modal').style.display = 'none';
        }

        function populateGoalModal() {
            const game = gameState.currentGame;
            
            // Atualizar nomes dos times
            document.getElementById('goal-team1-name').textContent = game.team1.name;
            document.getElementById('goal-team2-name').textContent = game.team2.name;
            
            // Mostrar jogadores de cada time
            populateTeamPlayers('team1');
            populateTeamPlayers('team2');
            
            // Esconder seção de assistência
            document.getElementById('assist-section').style.display = 'none';
        }

        function populateTeamPlayers(team) {
            const game = gameState.currentGame;
            const teamData = team === 'team1' ? game.team1 : game.team2;
            const container = document.getElementById(`goal-${team}-players`);
            
            container.innerHTML = teamData.players.map(player => `
                <div class="player-option" onclick="selectGoalPlayer('${team}', '${player}')">
                    <input type="radio" name="goal-player" value="${player}" id="goal-${team}-${player}">
                    <label for="goal-${team}-${player}">${player}</label>
                </div>
            `).join('');
        }

        function selectGoalTeam(team) {
            selectedGoalTeam = team;
            
            // Destacar time selecionado
            document.querySelectorAll('.team-card').forEach(card => {
                card.style.border = '3px solid #dee2e6';
            });
            
            const selectedCard = document.querySelector(`#goal-${team}-players`).closest('.team-card');
            selectedCard.style.border = '3px solid #3498db';
            
            // Atualizar combobox de assistência
            updateAssistSelect(team);
        }

        function selectGoalPlayer(team, player) {
            selectedGoalTeam = team;
            selectedGoalPlayer = player;
            
            // Marcar o jogador selecionado
            document.querySelectorAll('input[name="goal-player"]').forEach(input => {
                input.checked = false;
            });
            document.getElementById(`goal-${team}-${player}`).checked = true;
            
            // Destacar time selecionado
            selectGoalTeam(team);
        }

        function updateAssistSelect(team) {
            const game = gameState.currentGame;
            const teamData = team === 'team1' ? game.team1 : game.team2;
            const assistSelect = document.getElementById('assist-player-select');
            const assistSection = document.getElementById('assist-section');
            
            assistSelect.innerHTML = '<option value="">Nenhuma assistência</option>';
            teamData.players.forEach(player => {
                assistSelect.innerHTML += `<option value="${player}">${player}</option>`;
            });
            
            assistSection.style.display = 'block';
        }

        function registerGoal() {
            if (!selectedGoalTeam || !selectedGoalPlayer) {
                alert('Selecione o time e o jogador que marcou o gol!');
                return;
            }
            
            const assistPlayer = document.getElementById('assist-player-select').value;
            
            // Verificar se o jogador ainda existe no time (proteção extra)
            const game = gameState.currentGame;
            const team = selectedGoalTeam === 'team1' ? game.team1 : game.team2;
            
            if (!team.players.includes(selectedGoalPlayer)) {
                alert('Erro: Jogador não encontrado no time. Atualizando lista...');
                populateGoalModal();
                return;
            }
            
            // Garantir que as estatísticas existem para o jogador
            if (!game.stats[selectedGoalTeam][selectedGoalPlayer]) {
                game.stats[selectedGoalTeam][selectedGoalPlayer] = { goals: 0, assists: 0 };
            }
            
            if (assistPlayer && !game.stats[selectedGoalTeam][assistPlayer]) {
                game.stats[selectedGoalTeam][assistPlayer] = { goals: 0, assists: 0 };
            }
            
            // Atualizar placar
            gameState.currentGame.score[selectedGoalTeam]++;
            
            // Atualizar estatísticas
            gameState.currentGame.stats[selectedGoalTeam][selectedGoalPlayer].goals++;
            if (assistPlayer) {
                gameState.currentGame.stats[selectedGoalTeam][assistPlayer].assists++;
            }
            
            // Atualizar display
            document.getElementById(`${selectedGoalTeam}-score`).textContent = gameState.currentGame.score[selectedGoalTeam];
            
            // Adicionar ao histórico
            const teamName = selectedGoalTeam === 'team1' ? game.team1.name : game.team2.name;
            let historyText = `⚽ GOL! ${selectedGoalPlayer} (${teamName}) - ${formatTime(gameState.timer)}`;
            
            if (assistPlayer) {
                historyText += ` | Assistência: ${assistPlayer}`;
            }
            
            addToHistory(historyText);
            updateTeamsDisplay();
            closeGoalModal();
            saveGameState();
        }

        // Funções de gol contra
        function openOwnGoalModal() {
            populateOwnGoalPlayers();
            document.getElementById('own-goal-modal').style.display = 'block';
        }

        function closeOwnGoalModal() {
            document.getElementById('own-goal-modal').style.display = 'none';
        }

        function populateOwnGoalPlayers() {
            const teamSelect = document.getElementById('own-goal-team');
            const game = gameState.currentGame;
            
            teamSelect.innerHTML = `
                <option value="team1">${game.team1.name}</option>
                <option value="team2">${game.team2.name}</option>
            `;
            
            teamSelect.onchange = updateOwnGoalPlayersSelection;
            updateOwnGoalPlayersSelection();
        }

        function updateOwnGoalPlayersSelection() {
            const teamSelect = document.getElementById('own-goal-team');
            const selectedTeam = teamSelect.value;
            const game = gameState.currentGame;
            const team = selectedTeam === 'team1' ? game.team1 : game.team2;
            
            const ownGoalPlayersDiv = document.getElementById('own-goal-players');
            
            ownGoalPlayersDiv.innerHTML = team.players.map(player => `
                <div class="player-option">
                    <input type="radio" name="own-goal-player" value="${player}" id="own-goal-${player}">
                    <label for="own-goal-${player}">${player}</label>
                </div>
            `).join('');
        }

        function registerOwnGoal() {
            const teamSelect = document.getElementById('own-goal-team');
            const selectedTeam = teamSelect.value;
            const ownGoalPlayer = document.querySelector('input[name="own-goal-player"]:checked');
            
            if (!ownGoalPlayer) {
                alert('Selecione quem fez o gol contra!');
                return;
            }
            
            // Atualizar placar (ponto para o time adversário)
            const oppositeTeam = selectedTeam === 'team1' ? 'team2' : 'team1';
            gameState.currentGame.score[oppositeTeam]++;
            
            // Atualizar display
            document.getElementById(`${oppositeTeam}-score`).textContent = gameState.currentGame.score[oppositeTeam];
            
            // Adicionar ao histórico
            const game = gameState.currentGame;
            const teamName = selectedTeam === 'team1' ? game.team1.name : game.team2.name;
            const historyText = `🔴 GOL CONTRA! ${ownGoalPlayer.value} (${teamName}) - ${formatTime(gameState.timer)}`;
            
            addToHistory(historyText);
            closeOwnGoalModal();
            saveGameState();
        }

        // Gestão de jogadores
        function openPlayerManagement() {
            updatePlayerActionContent();
            document.getElementById('player-management-modal').style.display = 'block';
        }

        function closePlayerManagement() {
            document.getElementById('player-management-modal').style.display = 'none';
        }

        function updatePlayerActionContent() {
            const action = document.getElementById('player-action').value;
            const content = document.getElementById('player-action-content');
            const game = gameState.currentGame;
            
            switch (action) {
                case 'add':
                    content.innerHTML = `
                        <div class="form-group">
                            <label>Selecione o time:</label>
                            <select id="add-team">
                                <option value="team1">${game.team1.name}</option>
                                <option value="team2">${game.team2.name}</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Nome do jogador:</label>
                            <input type="text" id="new-player-name" placeholder="Digite o nome do jogador">
                        </div>
                    `;
                    break;
                    
                case 'remove':
                    content.innerHTML = `
                        <div class="form-group">
                            <label>Selecione o time:</label>
                            <select id="remove-team" onchange="updateRemovePlayersList()">
                                <option value="team1">${game.team1.name}</option>
                                <option value="team2">${game.team2.name}</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Selecione o jogador para remover:</label>
                            <div id="remove-players-list"></div>
                        </div>
                    `;
                    updateRemovePlayersList();
                    break;
                    
                case 'swap':
                    content.innerHTML = `
                        <div class="form-group">
                            <label>Jogador do ${game.team1.name}:</label>
                            <select id="swap-player1">
                                ${game.team1.players.map(p => `<option value="${p}">${p}</option>`).join('')}
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Jogador do ${game.team2.name}:</label>
                            <select id="swap-player2">
                                ${game.team2.players.map(p => `<option value="${p}">${p}</option>`).join('')}
                            </select>
                        </div>
                    `;
                    break;
            }
        }

        function updateRemovePlayersList() {
            const teamSelect = document.getElementById('remove-team');
            const selectedTeam = teamSelect.value;
            const game = gameState.currentGame;
            const team = selectedTeam === 'team1' ? game.team1 : game.team2;
            
            const playersListDiv = document.getElementById('remove-players-list');
            playersListDiv.innerHTML = team.players.map(player => `
                <div class="player-option">
                    <input type="radio" name="remove-player" value="${player}" id="remove-${player}">
                    <label for="remove-${player}">${player}</label>
                </div>
            `).join('');
        }

        function executePlayerAction() {
            const action = document.getElementById('player-action').value;
            
            switch (action) {
                case 'add':
                    addPlayer();
                    break;
                case 'remove':
                    removePlayer();
                    break;
                case 'swap':
                    swapPlayers();
                    break;
            }
        }

        function addPlayer() {
            const teamSelect = document.getElementById('add-team');
            const playerName = document.getElementById('new-player-name').value.trim();
            
            if (!playerName) {
                alert('Digite o nome do jogador!');
                return;
            }
            
            const selectedTeam = teamSelect.value;
            const game = gameState.currentGame;
            const team = selectedTeam === 'team1' ? game.team1 : game.team2;
            
            if (team.players.includes(playerName)) {
                alert('Este jogador já está no time!');
                return;
            }
            
            // Verificar se o jogador já existe no outro time
            const otherTeam = selectedTeam === 'team1' ? game.team2 : game.team1;
            if (otherTeam.players.includes(playerName)) {
                alert('Este jogador já está no outro time!');
                return;
            }
            
            team.players.push(playerName);
            
            // Inicializar estatísticas para o novo jogador
            game.stats[selectedTeam][playerName] = { goals: 0, assists: 0 };
            
            addToHistory(`➕ ${playerName} foi adicionado ao ${team.name} - ${formatTime(gameState.timer)}`);
            
            // Atualizar TODOS os displays e modais
            updateTeamsDisplay();
            updateAllModalsContent();
            
            closePlayerManagement();
            saveGameState();
        }

        function removePlayer() {
            const teamSelect = document.getElementById('remove-team');
            const playerToRemove = document.querySelector('input[name="remove-player"]:checked');
            
            if (!playerToRemove) {
                alert('Selecione um jogador para remover!');
                return;
            }
            
            const selectedTeam = teamSelect.value;
            const game = gameState.currentGame;
            const team = selectedTeam === 'team1' ? game.team1 : game.team2;
            
            const playerIndex = team.players.indexOf(playerToRemove.value);
            if (playerIndex > -1) {
                team.players.splice(playerIndex, 1);
                
                // Remover estatísticas do jogador também
                delete game.stats[selectedTeam][playerToRemove.value];
                
                addToHistory(`➖ ${playerToRemove.value} foi removido do ${team.name} - ${formatTime(gameState.timer)}`);
                
                // Verificar se o time ficou com menos jogadores
                if (team.players.length < gameState.playersPerTeam) {
                    alert(`Atenção: ${team.name} agora tem apenas ${team.players.length} jogadores!`);
                }
            }
            
            // Atualizar TODOS os displays e modais
            updateTeamsDisplay();
            updateAllModalsContent();
            
            closePlayerManagement();
            saveGameState();
        }

        function swapPlayers() {
            const player1Select = document.getElementById('swap-player1');
            const player2Select = document.getElementById('swap-player2');
            
            if (!player1Select.value || !player2Select.value) {
                alert('Selecione os dois jogadores para trocar!');
                return;
            }
            
            const game = gameState.currentGame;
            const player1 = player1Select.value;
            const player2 = player2Select.value;
            
            // Trocar jogadores
            const player1Index = game.team1.players.indexOf(player1);
            const player2Index = game.team2.players.indexOf(player2);
            
            game.team1.players[player1Index] = player2;
            game.team2.players[player2Index] = player1;
            
            // Trocar estatísticas também
            const player1Stats = game.stats.team1[player1] || { goals: 0, assists: 0 };
            const player2Stats = game.stats.team2[player2] || { goals: 0, assists: 0 };
            
            // Remover estatísticas antigas
            delete game.stats.team1[player1];
            delete game.stats.team2[player2];
            
            // Adicionar estatísticas nos novos times
            game.stats.team1[player2] = player2Stats;
            game.stats.team2[player1] = player1Stats;
            
            addToHistory(`🔄 Troca: ${player1} (${game.team1.name}) ↔ ${player2} (${game.team2.name}) - ${formatTime(gameState.timer)}`);
            
            // Atualizar TODOS os displays e modais
            updateTeamsDisplay();
            updateAllModalsContent();
            
            closePlayerManagement();
            saveGameState();
        }

        // Função para atualizar todos os modais e conteúdos
        function updateAllModalsContent() {
            // Atualizar modal de gestão de jogadores se estiver aberto
            const playerManagementModal = document.getElementById('player-management-modal');
            if (playerManagementModal.style.display === 'block') {
                updatePlayerActionContent();
            }
            
            // Se o modal de gol estiver aberto, atualizar também
            const goalModal = document.getElementById('goal-modal');
            if (goalModal.style.display === 'block') {
                populateGoalModal();
            }
            
            // Se o modal de gol contra estiver aberto, atualizar também
            const ownGoalModal = document.getElementById('own-goal-modal');
            if (ownGoalModal.style.display === 'block') {
                populateOwnGoalPlayers();
            }
        }

        document.getElementById('player-action').onchange = updatePlayerActionContent;

        // Histórico
        function addToHistory(text) {
            gameState.history.push({
                text: text,
                timestamp: new Date().toLocaleTimeString()
            });
            updateGameHistory();
        }

        function updateGameHistory() {
            const historyDiv = document.getElementById('game-history');
            historyDiv.innerHTML = gameState.history.map(item => 
                `<div class="history-item">${item.text}</div>`
            ).join('');
            historyDiv.scrollTop = historyDiv.scrollHeight;
        }

        // Encerrar jogo
        function endGame() {
            if (confirm('Tem certeza que deseja encerrar o jogo?')) {
                if (gameState.timerInterval) {
                    clearInterval(gameState.timerInterval);
                }
                gameState.timer.running = false;
                
                addToHistory(`🏁 Jogo encerrado aos ${formatTime(gameState.timer)}`);
                generateFinalReport();
                showScreen('final-report-screen');
                saveGameState();
            }
        }

        function generateFinalReport() {
            const game = gameState.currentGame;
            const content = document.getElementById('final-report-content');
            
            const winner = game.score.team1 > game.score.team2 ? game.team1.name : 
                          game.score.team2 > game.score.team1 ? game.team2.name : 'Empate';
            
            content.innerHTML = `
                <div class="game-screen" style="color: #333;">
                    <div class="scoreboard">
                        <div class="team-score">
                            <h3>${game.team1.name}</h3>
                            <div class="score">${game.score.team1}</div>
                        </div>
                        <div class="vs">VS</div>
                        <div class="team-score">
                            <h3>${game.team2.name}</h3>
                            <div class="score">${game.score.team2}</div>
                        </div>
                    </div>
                    
                    <div style="text-align: center; margin: 20px 0;">
                        <h2>${winner === 'Empate' ? '🤝 EMPATE!' : `🏆 VENCEDOR: ${winner}!`}</h2>
                        <p><strong>Tempo de jogo:</strong> ${formatTime(gameState.timer)}</p>
                    </div>
                    
                    <div class="history">
                        <h3>📋 Resumo da Partida</h3>
                        ${gameState.history.map(item => `<div class="history-item">${item.text}</div>`).join('')}
                    </div>
                    
                    <div style="margin-top: 20px;">
                        <h3>👥 Escalações Finais</h3>
                        <div class="teams-grid">
                            <div class="team-card">
                                <div class="team-header">
                                    <div class="team-name">${game.team1.name}</div>
                                    <div class="player-count">${game.team1.players.length} jogadores</div>
                                </div>
                                <div class="players-list">
                                    ${game.team1.players.map(player => `<div class="player-item">${player}</div>`).join('')}
                                </div>
                            </div>
                            <div class="team-card">
                                <div class="team-header">
                                    <div class="team-name">${game.team2.name}</div>
                                    <div class="player-count">${game.team2.players.length} jogadores</div>
                                </div>
                                <div class="players-list">
                                    ${game.team2.players.map(player => `<div class="player-item">${player}</div>`).join('')}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        }

        function shareFinalReport() {
            const game = gameState.currentGame;
            const winner = game.score.team1 > game.score.team2 ? game.team1.name : 
                          game.score.team2 > game.score.team1 ? game.team2.name : 'Empate';
            
            let message = "⚽ *RELATÓRIO FINAL DA PARTIDA* ⚽\n\n";
            message += `🏆 *RESULTADO FINAL*\n`;
            message += `${game.team1.name} ${game.score.team1} x ${game.score.team2} ${game.team2.name}\n\n`;
            
            if (winner === 'Empate') {
                message += "🤝 *EMPATE!*\n\n";
            } else {
                message += `🏆 *VENCEDOR: ${winner}!*\n\n`;
            }
            
            message += `⏱️ *Tempo de jogo:* ${formatTime(gameState.timer)}\n\n`;
            
            message += "📋 *RESUMO DA PARTIDA:*\n";
            gameState.history.forEach(item => {
                message += `• ${item.text}\n`;
            });
            
            message += "\n🎉 Parabéns a todos os jogadores!";
            
            const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(message)}`;
            window.open(whatsappUrl, '_blank');
        }

        function newGame() {
            if (confirm('Iniciar um novo jogo? Todos os dados atuais serão perdidos.')) {
                gameState = {
                    teams: [],
                    currentGame: null,
                    timer: { minutes: 0, seconds: 0, running: false },
                    timerInterval: null,
                    history: [],
                    teamCount: 2,
                    playersPerTeam: 5,
                    selectedTeams: []
                };
                localStorage.removeItem('soccerGameState');
                localStorage.removeItem('currentScreen');
                showScreen('setup-screen');
            }
        }

        // Inicialização
        document.addEventListener('DOMContentLoaded', function() {
            loadGameState();
        });

        // Salvar estado quando a página for fechada
        window.addEventListener('beforeunload', function() {
            saveGameState();
        });
    </script>
</body>
</html>
