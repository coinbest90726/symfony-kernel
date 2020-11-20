<?php

namespace App;

use Symfony\Component\DependencyInjection\Loader\Configurator\ContainerConfigurator;
use Symfony\Component\HttpKernel\Kernel as BaseKernel;
use Symfony\Component\Routing\Loader\Configurator\RoutingConfigurator;
use Symfony\Bundle\FrameworkBundle\Kernel\MicroKernelTrait;

/**
 * Class Kernel
 *
 * @package App
 */
class Kernel extends BaseKernel
{
    use MicroKernelTrait;

    /**
     * Config extensions
     *
     * @var string
     */
    private const CONFIG_EXTS = '.{php,xml,yaml,yml}';

    /**
     * Kernel constructor.
     *
     * @param          $env
     * @param          $debug
     * @param int|null $proid
     */
    public function __construct($env, $debug, int $proid = null)
    {
        $this->proid = $proid;

        parent::__construct($env, $debug);
    }

    protected function configureContainer(ContainerConfigurator $container): void
    {
        $container->import('../config/{packages}/*.yaml');
        $container->import('../config/{packages}/'.$this->getEnvironment().'/*.yaml');
        $container->parameters()->set('container.dumper.inline_class_loader', true);

        if (is_file(\dirname(__DIR__).'/config/services.yaml')) {
            $container->import('../config/services.yaml');
            $container->import('../config/{services}_'.$this->getEnvironment().'.yaml');
        } elseif (is_file($path = \dirname(__DIR__).'/config/services.php')) {
            (require $path)($container->withPath($path), $this);
        }
    }

    protected function configureRoutes(RoutingConfigurator $routes): void
    {
        $routes->import('../config/{routes}/'.$this->getEnvironment().'/*.yaml');
        $routes->import('../config/{routes}/*.yaml');

        if (is_file(\dirname(__DIR__).'/config/routes.yaml')) {
            $routes->import('../config/routes.yaml');
        } elseif (is_file($path = \dirname(__DIR__).'/config/routes.php')) {
            (require $path)($routes->withPath($path), $this);
        }
    }

    public function getCacheDir(): string
    {
        return $this->getProjectDir().'/var/cache/' . $this->getEnvironment() . '/' . $this->proid;
    }

    public function getLogDir(): string
    {
        return $this->getProjectDir().'/var/log/' . $this->getEnvironment() . '/' . $this->proid;
    }

    public function runningInConsole(): bool
    {
        if (in_array(PHP_SAPI, ['cli', 'phpdbg', 'embed'], true)) {
            return true;
        }
        return false;
    }
}
